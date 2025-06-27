#!/bin/bash

# Assign a physical network interface from the host to a container's network namespace

set -e

CONTAINER_NAME=$1
INTERFACE_HOST=$2
INTERFACE_CONTAINER=$3
IP_ADDRESS=$4
NETMASK=$5

if [[ -z "$CONTAINER_NAME" || -z "$INTERFACE_HOST" || -z "$INTERFACE_CONTAINER" || -z "$IP_ADDRESS" || -z "$NETMASK" ]]; then
    echo "Usage: $0 <container_name> <host_interface> <container_interface> <ip_address> <netmask>"
    exit 1
fi

PID=$(docker inspect -f '{{.State.Pid}}' "${CONTAINER_NAME}" 2>/dev/null)
if [[ -z "$PID" ]]; then
    echo "Container '${CONTAINER_NAME}' not found or not running."
    exit 1
fi

mkdir -p /var/run/netns
ln -sf /proc/$PID/ns/net /var/run/netns/$PID

ip link set "$INTERFACE_HOST" netns "$PID"

ip netns exec "$PID" ip link set "$INTERFACE_HOST" name "$INTERFACE_CONTAINER"
ip netns exec "$PID" ip addr add "${IP_ADDRESS}/${NETMASK}" dev "${INTERFACE_CONTAINER}"
ip netns exec "$PID" ip link set "${INTERFACE_CONTAINER}" up

rm -f /var/run/netns/$PID

echo "Interface '${INTERFACE_HOST}' has been assigned to container '${CONTAINER_NAME}' as '${INTERFACE_CONTAINER}' with IP ${IP_ADDRESS}/${NETMASK}."
