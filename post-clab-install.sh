#!/bin/bash

systemctl start docker
minikube start --nodes 2 -p mkcluster --cpus=1 --force
minikube profile list  
minikube profile mkcluster
minikube kubectl get nodes
minikube kubectl describe node mkcluster | grep Taints
minikube kubectl taint nodes mkcluster node-role.kubernetes.io/master:NoSchedule-

sudo ip link add name br-clab type bridge
sudo ip link set br-clab up
ip link show type bridge

clab deploy -t clab_frr_minikube.yaml
clab inspect -t clab_frr_minikube.yaml
