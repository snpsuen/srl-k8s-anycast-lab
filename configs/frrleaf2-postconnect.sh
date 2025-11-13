#!/bin/bash
# frrleaf2-postconnect.sh
# Attach frrleaf2 to the minikube Docker network and configure eth3

set -e

echo "[INFO] Attaching frrleaf2 to mkcluster network..."
PID=$(docker inspect -f '{{.State.Pid}}' frrleaf2)
BR=$(docker network inspect mkcluster | grep '"com.docker.network.bridge.name"' | awk -F '"' '{print $4}')

if [ -z "$BR" ]; then
  echo "[ERROR] mkcluster network bridge not found."
  exit 1
fi

echo "[INFO] Using bridge: $BR"
ip link add veth-frr type veth peer name veth-host
ip link set veth-frr netns $PID
nsenter -t $PID -n ip link set veth-frr name eth3
nsenter -t $PID -n ip addr add 192.168.49.101/24 dev eth3
nsenter -t $PID -n ip link set eth3 up
ip link set veth-host master $BR
ip link set veth-host up

echo "[INFO] frrleaf2 successfully connected to mkcluster (eth3 = 192.168.49.101)"
