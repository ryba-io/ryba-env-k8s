
## Ryba environment and actions for installing Kubernetes

## Installation

This is a Node.js project. It expect GIT, Vagrant, Node.js and NPM to be present.

```
git clone https://github.com/ryba-io/ryba-env-metal.git
cd ryba-env-metal
npm install
./bin/vagrant up
./bin/ryba install
```

## Tear Down

This is not yet implemented, here temporarily.

On Master for all nodes

```
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
```

On each nodes

```
rm -f /etc/kubernetes/kubelet.conf
# Free port 10250, otherwise kubeadm will not pass pre-flight checks
systemctl restart kubelet
```

On Master

```
kubeadm reset
```
