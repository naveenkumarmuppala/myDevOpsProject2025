#!/bin/bash
set -eux

exec > /var/log/user-data.log 2>&1

apt-get update -y

# Install dependencies
apt-get install -y ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings

# Docker GPG
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
-o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

# Docker repo
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt-get update -y

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu
chmod 666 /var/run/docker.sock

#Install Dependencies for monitoring
apt-get update -y
apt-get install -y wget curl tar adduser libfontconfig1

# =========================
# Install Grafana
# =========================
wget https://dl.grafana.com/grafana-enterprise/release/12.4.2/grafana-enterprise_12.4.2_23531306697_linux_amd64.deb
apt-get install -y ./grafana-enterprise_12.4.2_23531306697_linux_amd64.deb

systemctl daemon-reexec
systemctl enable grafana-server
systemctl start grafana-server

# =========================
# Install Prometheus
# =========================
cd /opt

wget https://github.com/prometheus/prometheus/releases/download/v3.5.1/prometheus-3.5.1.linux-amd64.tar.gz
tar -xvf prometheus-3.5.1.linux-amd64.tar.gz
mv prometheus-3.5.1.linux-amd64 prometheus

useradd --no-create-home --shell /bin/false prometheus
mkdir -p /opt/prometheus/data

chown -R prometheus:prometheus /opt/prometheus

# Prometheus service
cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/opt/prometheus/prometheus \
  --config.file=/opt/prometheus/prometheus.yml \
  --storage.tsdb.path=/opt/prometheus/data

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

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

echo "Monitoring stack installed successfully"