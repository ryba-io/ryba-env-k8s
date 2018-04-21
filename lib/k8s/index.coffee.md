
# Kubernetes

    module.exports =
      # id: 'ryba/k8s/kubeadm'
      deps:
        docker: module: 'masson/commons/docker', local: true
      configure:
        './lib/k8s/configure'
      commands:
        'install': './lib/k8s/install'
        'info': './lib/k8s/info'
