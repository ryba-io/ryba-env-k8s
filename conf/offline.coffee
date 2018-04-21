
module.exports =
  clusters: 'vagrant': services:
    'masson/core/yum':
      options:
        config: proxy: null
        repo:
          source: "#{__dirname}/offline/centos.repo"
        epel:
          url: null
          source: "#{__dirname}/offline/epel.repo"
    # 'masson/core/network':
    #   options:
    #     ifcfg:
    #       eth0:
    #         PEERDNS: 'yes' # Prevent dhcp-client to overwrite /etc/resolv.conf
    #       eth1:
    #         PEERDNS: 'yes' # Prevent dhcp-client to overwrite /etc/resolv.conf
    # './lib/k8s':
    #   options:
    #     repo: source: "#{__dirname}/offline/kubernetes.repo"
    # 'ryba/ambari/repo':
    #   options:
    #     source: "#{__dirname}/offline/ambari-2.4.2.0.repo"
    # 'ryba/grafana/repo':
    #   constraints: nodes: ['edge01.metal.ryba']
    #   options:
    #     source: "#{__dirname}/offline/grafana.repo"
