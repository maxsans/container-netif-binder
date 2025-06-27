# container-netif-binder

**Bind and unbind physical network interfaces to Linux containers (e.g. Docker) using native network namespaces.**

## Overview

This project provides portable Bash scripts to:
- Assign a physical interface (like `eth1`) to a container's network namespace.
- Reclaim the interface from the container back to the host.

These scripts are based on Linux network namespaces and are container runtime–agnostic (Docker, Podman, etc.).

---

## Requirements

- Linux system (with `iproute2`)
- Root privileges (`sudo`)
- Docker installed (for default usage)

---

## Files

### `scripts/assign-interface.sh`

Assign a physical network interface to a container and configure it with a static IP.

```bash
sudo ./scripts/assign-interface.sh <container_name> <host_interface> <container_interface> <ip_address> <netmask>
````

**Example:**

```bash
sudo ./scripts/assign-interface.sh mycontainer eth1 net1 192.168.1.100 24
```

---

### `scripts/reclaim-interface.sh`

Reclaim the interface from the container back to the host.

```bash
sudo ./scripts/reclaim-interface.sh <container_name> <interface_name_in_container>
```

**Example:**

```bash
sudo ./scripts/reclaim-interface.sh mycontainer net1
```

---

## Notes

* The container must be running.
* It’s recommended to start it with `--network=none` to avoid interference from default Docker networking.
* You can use this on **any container** if you know the container’s **PID** and it exposes a Linux netns.

---

## Examples

See [`examples/usage.md`](examples/usage.md) for a full Docker setup walkthrough.

---

## 🛡 License

MIT — see [LICENSE](LICENSE)

```
