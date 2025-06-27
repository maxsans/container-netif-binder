#!/bin/bash

# Reclaim a physical network interface from a container's network namespace back to the host

set -e

CONTAINER_NAME=$1
INTERFACE_NAME=$2

if [[ -z "$CONTAINER_NAME" || -z "$INTERFACE_NAME" ]]; then
    echo "Usage: $0 <container_name> <interface_name_in_container>"
    exit 1
fi

PID=$(docker inspect -f '{{.State.Pid}}' "${CONTAINER_NAME}" 2>/dev/null)
if [[ -z "$PID" ]]; then
    echo "Container '${CONTAINER_NAME}' not found or not running."
    exit 1
fi

mkdir -p /var/run/netns
ln -sf /proc/$PID/ns/net /var/run/netns/$PID

ip netns exec "$PID" ip link set "$INTERFACE_NAME" netns 1

rm -f /var/run/netns/$PID

echo "Interface '${INTERFACE_NAME}' has been reclaimed from container '${CONTAINER_NAME}' and is now back on the host."
