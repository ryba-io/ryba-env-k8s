
# Kubernetes Install

    module.exports = header: 'K8s Install', handler: (options) ->

## System

Addtionnal check includes:
* unique MAC address: get the MAC address of the network interfaces using the command `ip link` or `ifconfig -a`
* unique product\_uuid: the uuid can be checked by using the command `sudo cat /sys/class/dmi/id/product_uuid`

      @system.mod
        header: 'Module br_netfilter'
        name: 'br_netfilter'
      @tools.sysctl
        properties:
          'net.bridge.bridge-nf-call-ip6tables': 1
          'net.bridge.bridge-nf-call-iptables': 1
      @system.execute
        header: 'Disable SWAP'
        cmd: """
        [ `swapon -s | wc -l` == 0 ] && exit 3
        sed -i.bak '/ swap / s/^[^#]/#/' /etc/fstab
        swapoff -a
        """
        code_skipped: 3
      @system.execute.assert
        header: 'System Validation'
        cmd: """
        # SELinux is disabled
        sestatus | grep 'SELinux status:' | egrep 'disabled|permissive'
        # Swap is disabled
        [ `swapon -s | wc -l` == 0 ]
        # Bridge kernel module is loaded
        lsmod | grep br_netfilter
        # Bridge is forwarding to iptables
        sysctl -a | grep 'net.bridge.bridge-nf-call-ip6tables = 1'
        sysctl -a | grep 'net.bridge.bridge-nf-call-iptables = 1'
        """
        trap: true

## Repository

      @tools.repo
        header: 'Repository'
        source: options.repo.source
        target: options.repo.target
        replace: options.repo.replace
        update: true

## Packages

Installing the "kubeadm" package also enrich the "kubelet" service with an entry
in " /etc/systemd/system/kubelet.service.d/10-kubeadm.conf".

      @service
        header: 'Service kubelet'
        name: 'kubelet'
        startup: true
      @service
        header: 'Package kubeadm'
        name: 'kubeadm'
      @system.execute
        header: 'Reload kubelet'
        cmd: """
        systemctl status kubelet 2>&1 | grep daemon-reload || exit 3
        systemctl daemon-reload
        """
        code_skipped: 3
      @service
        header: 'Package kubectl'
        name: 'kubectl'
      @service.start
        header: 'Service kubelet'
        name: 'kubelet'
      @service

## Init

      # Master
      @call
        header: 'Init'
        if: options.master
        unless_exists: '/etc/kubernetes/kubelet.conf'
      , ->
        @system.execute
          cmd: "kubeadm init #{options.init_args}".trim()
        , (err, status, stdout) ->
          throw err if err
          @kv.set
            key: 'k8s_join'
            value: /kubeadm join.*/.exec(stdout)[0]
      @call
        header: 'Init'
        if: options.master
        if_exists: '/etc/kubernetes/kubelet.conf'
        if: options.init_args.token
      , ->
          @kv.set
            key: 'k8s_join'
            value: "kubeadm join #{options.init_args.token}"
      # Node
      @call
        header: 'Join'
        unless: options.master
        unless_exists: '/etc/kubernetes/kubelet.conf'
      , ->
        @kv.get
          key: 'k8s_join'
        , (err, status, key, cmd) ->
          throw err if err
          @system.execute
            cmd: cmd

## Config

      @system.copy
        header: 'Config'
        if: options.master
        source: '/etc/kubernetes/admin.conf'
        target: '/root/.kube/config'
        # cmd: """
        # mkdir -p $HOME/.kube
        # sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
        # sudo chown $(id -u):$(id -g) $HOME/.kube/config
        # """

## CNI

      @call header: 'CNI', if: options.master, ->
        @system.execute
          header: 'weave-net'
          if: options.cni is 'weave-net'
          unless_exec: 'kubectl get daemonsets -n kube-system | grep weave-net'
          cmd: """
          export kubever=$(kubectl version | base64 | tr -d '\n')
          kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
          """
        @system.execute
          header: 'Caligo'
          if: options.cni is 'calico'
          unless_exec: 'kubectl get daemonsets -n kube-system | grep calico'
          cmd: """
          kubectl apply -f https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
          """
        @wait.execute
          header: 'Wait Nodes'
          if: options.master
          cmd: """
          [[ `kubectl get nodes | grep Ready | wc -l` == '#{options.cni_master_count + options.cni_node_count}' ]]
          """
        @wait.execute
          header: 'Wait DNS'
          if: options.master
          cmd: """
          kubectl get pods --all-namespaces | grep kube-dns- | grep #{options.cni_node_count}/#{options.cni_node_count}
          """

## Dashboard

      @call header: 'Dashboard', if: options.master, ->
        @system.execute
          header: 'Install'
          cmd: """
          kubectl -n kube-system get svc kubernetes-dashboard && exit 3
          kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
          """
          code_skipped: 3
        @system.execute
          header: 'Expose'
          cmd: """
          [[ `kubectl -n kube-system get svc kubernetes-dashboard -o go-template='{{.spec.type}}'` == 'NodePort' ]] && exit 3
          kubectl -n kube-system patch svc kubernetes-dashboard -p '{"spec":{"selector":{"k8s-app":"kubernetes-dashboard"},"type":"NodePort"}}}'
          """
          code_skipped: 3
        @system.execute
          header: 'Validate'
          cmd: """
          port=`kubectl -n kube-system get service kubernetes-dashboard -o go-template='{{ (index .spec.ports 0).nodePort}}'`
          echo > /dev/tcp/localhost/$port
          """
        # Follow instruction from https://github.com/kubernetes/dashboard/wiki/Creating-sample-user
        username = 'ryba-admin'
        @file
          header: "User #{username}"
          target: "/root/k8s/user-#{username}"
          content: """
          apiVersion: v1
          kind: ServiceAccount
          metadata:
            name: #{username}
            namespace: kube-system
          """
        @system.execute
          header: "Apply user #{username}"
          cmd: """
          kubectl apply -f "/root/k8s/user-#{username}"
          """
          shy: true
        @file
          header: 'Admin user role binding'
          target: "/root/k8s/user-#{username}-role-binding"
          content: """
          apiVersion: rbac.authorization.k8s.io/v1beta1
          kind: ClusterRoleBinding
          metadata:
            name: #{username}
          roleRef:
            apiGroup: rbac.authorization.k8s.io
            kind: ClusterRole
            name: cluster-admin
          subjects:
          - kind: ServiceAccount
            name: #{username}
            namespace: kube-system
          """
        @system.execute
          header: "Apply user #{username} role binding"
          cmd: """
          kubectl apply -f "/root/k8s/user-#{username}-role-binding"
          """
          shy: true
        @system.execute
          header: "Get token"
          cmd: """
          kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep #{username} | awk '{print $1}') | grep ^token: | sed 's/^token: *\\([a-z]\\)/\\1/'
          """
          shy: true

## Rancher

      @call header: 'Rancher', if: options.master, ->
        @system.execute
          cmd: """
          [ `docker ps --filter name=rancher -q | wc -l` == 1 ] && exit 3
          docker run -d --restart=unless-stopped -p 10080:80 -p 10443:443 --name rancher rancher/server:preview
          """
          code_skipped: 3
        # TODO: pilot registration through the REST API

    

          
