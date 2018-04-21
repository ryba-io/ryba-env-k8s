
# Kubernetes Configure

    module.exports = (service) ->
      {options} = service
      throw Error "No Master Found: kubernetes requires one one master" unless service.instances.some (instance) -> instance.options.master

## Repository

      options.repo ?= {}
      options.repo.source ?= path.resolve __dirname, './resources/kubernetes-el7.repo'
      options.repo.target ?= 'kubernetes.repo'
      options.repo.target = path.resolve '/etc/yum.repos.d', options.repo.target
      options.repo.replace ?= 'kubernetes*'

## CNI

      options.cni ?= 'calico'
      if options.cni is 'calico'
        options.init_args['pod-network-cidr'] ?= '192.168.0.0/16'
      options.cni_master_count = service.instances.filter( (instance) -> instance.options.master ).length
      options.cni_node_count = service.instances.filter( (instance) -> not instance.options.master ).length

## Init Options

Pass any options to the `kubeadm init` command. For exemple, set 
`{ init_args: { "apiserver-advertise-address": "10.10.10.44"}}` to force the 
API server to communicate on a given IP.

      options.init_args ?= {}
      throw Error 'Unsupported Option Type: string for init_args' if typeof options.init_args is 'string'
      options.init_args = (
        "--#{k}=#{v}" for k, v of options.init_args
      ).join ' '

## Command Specific

      # Ensure "prepare" is executed locally only once
      options.prepare = service.node.id is service.instances[0].id

## Dependencies

    path = require 'path'
