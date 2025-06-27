# 🧪 Usage Example with Docker

This guide walks through assigning and reclaiming a **physical network interface** to a **Docker container** using the `container-netif-binder` scripts.

---

## 🛠 Prerequisites

- A physical interface on your host (e.g. `eth1`) that is not currently in use.
- Docker installed and running.
- Root access (or sudo privileges).

---

## 1️⃣ Step 1: Create a container with no networking

```bash
docker run -dit --name test-container --network=none debian bash
````

Install basic tools in the container (optional but recommended):

```bash
docker exec -it test-container bash -c "apt update && apt install -y iproute2 iputils-ping"
```

---

## 2️⃣ Step 2: Assign a physical interface to the container

Assuming:

* Host interface: `eth1`
* Interface name in container: `net1`
* IP: `192.168.100.10`
* Netmask: `24`

```bash
sudo ./scripts/assign-interface.sh test-container eth1 net1 192.168.100.10 24
```

✅ Inside the container:

```bash
docker exec -it test-container bash
ip addr show net1
ping -c 3 192.168.100.1
```

---

## 3️⃣ Step 3: Reclaim the interface

When you're done testing or shutting down the container:

```bash
sudo ./scripts/reclaim-interface.sh test-container net1
```

Check on the host:

```bash
ip addr show eth1
```

It should now be available again on the host.

---

## 🧼 Step 4: Clean up

```bash
docker rm -f test-container
```

---

## 📝 Notes

* The interface must **not be managed by NetworkManager** or other host services while assigned to a container.
* You can use **veth pairs** or **macvlan** interfaces instead of physical interfaces for testing if needed.
