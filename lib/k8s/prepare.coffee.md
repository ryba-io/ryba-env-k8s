
# Kubernetes Prepare

    module.exports =
      header: 'K8S Prepare'
      if: (options) -> options.prepare
      ssh: false
      handler: (options) ->
        console.log 'todo'
        # @file.cache
        #   source: "#{options.source}"
        #   target: "#{options.cache_dir}/docker-compose"
        #   location: true
