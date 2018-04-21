
module.exports =
  nikita:
    domain: true
    cache_dir: "#{__dirname}/../cache"
    log_serializer: true
    debug: false
    clean_logs: true
    force_check: false
    log_md:
      archive: false
      rotate: true
    ssh:
      private_key: """
      -----BEGIN RSA PRIVATE KEY-----
      MIIEogIBAAKCAQEArBDFt50aN9jfIJ629pRGIMA1fCMb9RyTHt9A+jx3FOsIOtJs
      eaBIpv98drbFVURr+cUs/CrgGVk5k2NIeiz0bG4ONV5nTwx38z5CzqLb7UryZS3i
      a/TS14fWOxvWTRR27R71ePX90G/ZIReKFeTrucw9y9Pl+xAzsmeblRwLBxv/SWBX
      Uai2mHAZaejlG9dGkn9f2n+oPmbgk6krLMCjLhlNBnkdroBNSXGA9ewLPFF4y54Q
      kBqmG3eLzCqAKAzwyJ5PpybtNGAWfN81gY/P5LBzC66WdtEzpwsYAv1wCioqggtg
      xVZN2s0ajxQrCxahRkXstBI2IDcm2qUTxaDbUwIDAQABAoIBAFruOi7AvXxKBhCt
      D6/bx/vC2AEUZM/yG+Wywhn8HkpVsvGzBlR4Wiy208XA7SQUlqNWimFxHyEGQCEd
      1M2MOFedCbE2hI4H3tQTUSb2dhc/Bj5mM0QuC8aPKK3wFh6B9B93vu3/wfSHR03v
      rK/JXLHBt96hyuYVN9zOWDBCs6k7SdQ2BcsQLiPg6feTsZelJDuO+DO65kKLMiz3
      mNPThErklRaKovNk47LSYakk6gsJXrpG6JWQ6nwsRenwplDwZ8Zs9mlRi7f3nChM
      3I1WlISN8y2kcQBQ94YZKk8wzH/lzmxsabcLa5ETNubxQ6ThDu1oYUIIUsQyNPm+
      DkW0VwECgYEA5MttelspKexWS39Y3sQYvZ/v8VZBQl4tRbpUWWc+PNEtcEwOBza/
      H4jBWYd2eWKTApJT1st58E4b34Mv88nQVElLb3sE7uJMkihPyNpABGbCvr63hDYw
      PyL53nKaPelY/aDnL0F8LmREfdKw/uy6+UChgkPfdo2VVk1oyvsZaRMCgYEAwIZ+
      lCmeXQ4mU6uxO+ChhDn7zw9rR5qlCyfJiLPe2lV20vaHV5ZfKIWGegsVJSpFr2ST
      5ghh+FVIneoNRtTHEKwNWCK7I6qeF+WAaci+KsLQigJQHsw58n9cdA7wHHc475n/
      pf7efoPcvk6qYOS2mpDgC87m+o3C4Dyspqp9TMECgYA4/ed+dBjT5Zg1ZDp5+zUC
      f0Wgw1CsPJNgbCK4xnv9YEnGUFuqNlvzefhX2eOMJx7hpBuYRMVSM9LDoYUfYCUx
      6bQNyAIZk2tpePsu2BbcQdC+/PjvySPJhmfhnoCHbYoKW7tazSAm2jkpcoM+bS/C
      CPRyY3/Voz0Q62VwMo5I2wKBgB4mMbZUGieqapgZwASHdeO2DNftKzioYAYyMd5F
      hLWeQqBg2Or/cmFvH5MHH0WVrBn+Xybb0zPHbzrDh1a7RX035FMUBUhdlKpbV1O5
      iwY5Qd0K5a8c/koaZckK+dELXpAvBpjhI8ieL7hhq07HIk1sOJnAye0cvBLPjZ3/
      /uVBAoGAVAs6tFpS0pFlxmg4tfGEm7/aP6FhyBHNhv2QGluw8vv/XVMzUItxGIef
      HcSMWBm08IJMRJLgmoo1cuQv6hBui7JpDeZk/20qoF2oZW9lJ9fdRObJqi61wufP
      BNiriqexq/eTy2uF9RCCjLItWxUscVMlVt4V65HLkCF5WxCQw+o=
      -----END RSA PRIVATE KEY-----
      """
      public_key: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsEMW3nRo32N8gnrb2lEYgwDV8Ixv1HJMe30D6PHcU6wg60mx5oEim/3x2tsVVRGv5xSz8KuAZWTmTY0h6LPRsbg41XmdPDHfzPkLOotvtSvJlLeJr9NLXh9Y7G9ZNFHbtHvV49f3Qb9khF4oV5Ou5zD3L0+X7EDOyZ5uVHAsHG/9JYFdRqLaYcBlp6OUb10aSf1/af6g+ZuCTqSsswKMuGU0GeR2ugE1JcYD17As8UXjLnhCQGqYbd4vMKoAoDPDInk+nJu00YBZ83zWBj8/ksHMLrpZ20TOnCxgC/XAKKiqCC2DFVk3azRqPFCsLFqFGRey0EjYgNybapRPFoNtT Ryba Hadoop'
      root:
        username: 'vagrant'
        private_key_path: "~/.vagrant.d/insecure_private_key"
  clusters: 'vagrant': services:
    'masson/core/system':
      affinity: type: 'tags', values: 'environment': 'dev'
      options:
        selinux: false
        # sysctl:
        #   'net.bridge.bridge-nf-call-ip6tables': 1
        #   'net.bridge.bridge-nf-call-iptables': 1
        limits: {}
        users:
          ryba: {}
    'masson/core/yum':
      affinity: type: 'tags', values: 'environment': 'dev'
      options:
        update: true
        repo:
          update: true
          # clean: true
          # source: "#{__dirname}/offline/centos.repo"
        packages:
          'tree': true, 'git': true, 'htop': false, 'vim': true, 
          'bash-completion': true, 'net-tools': true # Install netstat
          # 'bind-utils': true # Install dig
        epel:
          enabled: false
    'masson/core/ssh':
      affinity: type: 'tags', values: 'environment': 'dev'
      options:
        banner:
          target: '/etc/banner'
          content: "Welcome to Hadoop!"
        sshd_config:
          PermitRootLogin: 'without-password'
    'masson/core/network':
      affinity: type: 'tags', values: 'environment': 'dev'
      options:
        hosts:
          '10.10.10.10': 'repos.ryba ryba'
        hosts_auto: true
        resolv: false
    'masson/core/ssl':
      affinity: type: 'tags', values: 'environment': 'dev'
      options:
        cacert:
          source: "#{__dirname}/certs/ca.cert.pem"
          local: true
    'masson/core/chrony':
      affinity: type: 'tags', values: 'environment': 'dev'
      options:
        server: 'master.k8s.ryba'
        server_config: """
        allow 10.10.10.0/24
        local stratum 10
        manual
        """
        client_config: """
        server 10.10.10.51 iburst
        """
    'masson/commons/docker':
      affinity: type: 'tags', values: 'environment': 'dev'
      options: {}
    './lib/k8s':
      affinity:
        type: 'tags', values: 'k8s_role':
          match: 'any'
          values: ['master', 'node']
      options:
        init_args:
          'token': '98b35c.5248b28f402fc603'
          'apiserver-advertise-address': '10.10.10.51'
          # "service-cidr": "10.20.0.0/16"
      nodes:
        'master.k8s.ryba': master: true
        # type: 'tags', values:
        # 'k8s_role': match: 'any', values: ['master', 'node']
  nodes:
    'master.k8s.ryba':
      ip: '10.10.10.51'
      tags:
        'environment': 'dev'
        'k8s_role': 'master'
      services:
        'vagrant:masson/core/ssl':
          'cert': source: "#{__dirname}/certs/master.cert.pem", local: true
          'key': source: "#{__dirname}/certs/master.key.pem", local: true
    'node01.k8s.ryba':
      ip: '10.10.10.52'
      tags:
        'environment': 'dev'
        'k8s_role': 'node'
      services:
        'vagrant:masson/core/ssl':
          'cert': source: "#{__dirname}/certs/node01.cert.pem", local: true
          'key': source: "#{__dirname}/certs/node01.key.pem", local: true
    'node02.k8s.ryba':
      ip: '10.10.10.53'
      tags:
        'environment': 'dev'
        'k8s_role': 'node'
      services:
        'vagrant:masson/core/ssl':
          'cert': source: "#{__dirname}/certs/node02.cert.pem", local: true
          'key': source: "#{__dirname}/certs/node02.key.pem", local: true
    'node03.k8s.ryba':
      ip: '10.10.10.54'
      tags:
        'environment': 'dev'
        'k8s_role': 'node'
      services:
        'vagrant:masson/core/ssl':
          'cert': source: "#{__dirname}/certs/node03.cert.pem", local: true
          'key': source: "#{__dirname}/certs/node03.key.pem", local: true
    'edge.k8s.ryba':
      ip: '10.10.10.58'
      tags:
        'environment': 'dev'
      services:
        'vagrant:masson/core/ssl':
          'cert': source: "#{__dirname}/certs/edge.cert.pem", local: true
          'key': source: "#{__dirname}/certs/edge.key.pem", local: true
