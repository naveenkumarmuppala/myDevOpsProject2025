#!/bin/bash
set -eux

# Log output for debugging
exec > /var/log/user-data.log 2>&1

# Update system
apt-get update -y

# Install containerd
apt-get install -y containerd

mkdir -p /etc/containerd

containerd config default \
| sed 's/SystemdCgroup = false/SystemdCgroup = true/' \
| sed 's|sandbox_image = ".*"|sandbox_image = "registry.k8s.io/pause:3.10"|' \
> /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Install dependencies
apt-get install -y apt-transport-https ca-certificates curl gpg

mkdir -p -m 755 /etc/apt/keyrings

# Add Kubernetes repo
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key \
| gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" \
> /etc/apt/sources.list.d/kubernetes.list

apt-get update -y

KUBE_VERSION="1.33.2-1.1"

apt-get install -y kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION

apt-mark hold kubelet kubeadm kubectl

# Enable networking
sysctl -w net.ipv4.ip_forward=1
sed -i '/^#net.ipv4.ip_forward=1/s/^#//' /etc/sysctl.conf
sysctl -p

echo "Kubernetes node setup completed"

#Install Node Exporter (for Kubernetes monitoring)
apt-get install -y wget tar

# =========================
# Install Node Exporter
# =========================
cd /opt

wget https://github.com/prometheus/node_exporter/releases/download/v1.11.1/node_exporter-1.11.1.linux-amd64.tar.gz
tar -xvf node_exporter-1.11.1.linux-amd64.tar.gz
mv node_exporter-1.11.1.linux-amd64 node_exporter

useradd --no-create-home --shell /bin/false node_exporter
chown -R node_exporter:node_exporter /opt/node_exporter

# Node Exporter service
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
ExecStart=/opt/node_exporter/node_exporter

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter