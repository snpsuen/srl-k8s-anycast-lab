#!/bin/bash
PID=$(docker inspect -f '{{.State.Pid}}' frrleaf2)
BR=$(docker network inspect mkcluster | grep '"com.docker.network.bridge.name"' | awk -F '"' '{print $4}')
ip link add veth-frr type veth peer name veth-host
ip link set veth-frr netns $PID
nsenter -t $PID -n ip link set veth-frr name eth3
nsenter -t $PID -n ip addr add 192.168.49.101/24 dev eth3
nsenter -t $PID -n ip link set eth3 up
ip link set veth-host master $BR
ip link set veth-host up
