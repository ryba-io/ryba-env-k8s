
# Kubernetes Install

    module.exports = header: 'K8s Info', handler: (options) ->

## Dashboard

      @call header: 'Dashboard', if: options.master, ->
        @system.execute
          header: 'Port'
          cmd: """
          echo `kubectl -n kube-system get service kubernetes-dashboard -o go-template='{{ (index .spec.ports 0).nodePort}}'`
          """
        , (err, status, stdout) ->
          console.log 'Port:', stdout
        @system.execute
          cmd: """
          kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep ryba-admin | awk '{print $1}') | grep ^token: | sed 's/^token: *\\([a-z]\\)/\\1/'
          """
          shy: true
        , (err, status, stdout) ->
          console.log 'Token:', stdout
          
