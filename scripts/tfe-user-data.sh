#!/usr/bin/env bash

set -euo pipefail

# The default username assigned to UID 1000 in AWS EC2 instances.
USERNAME="admin"

# Docker

DEBIAN_FRONTEND=noninteractive apt-get -yq update
DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade
DEBIAN_FRONTEND=noninteractive apt-get -yq install apt-transport-https ca-certificates curl gnupg

# Setup Docker's apt repository.
docker_gpg_url="https://download.docker.com/linux/debian/gpg"
apt_keyring_dir="/usr/share/keyrings"

curl -fsSL "${docker_gpg_url}" | gpg --dearmor -o "${apt_keyring_dir}/docker.gpg"

chmod a+r "${apt_keyring_dir}"/docker.gpg

cat <<'EOF' >/etc/apt/sources.list.d/docker.sources
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: bookworm
Components: stable
arch: amd64
signed-by: /usr/share/keyrings/docker.gpg
EOF

# Enable ipv4 forwarding, requires on CIS hardened machines.
sysctl net.ipv4.conf.all.forwarding=1

cat <<'EOF' >/etc/sysctl.d/enabled_ipv4_forwarding.conf
net.ipv4.conf.all.forwarding=1
EOF

# Install Docker and prerequisites.
DEBIAN_FRONTEND=noninteractive apt-get -yq update
DEBIAN_FRONTEND=noninteractive apt-get -yq install docker-ce docker-ce-cli unzip jq

# Add the admin user to the docker group (created automatically as part of install).
usermod -aG docker "${USERNAME}"

# TLS Certificate

tfe_hostname="tfe.craig-sloggett.sbx.hashidemos.io"

hashicorp_license="$(aws secretsmanager get-secret-value \
  --secret-id tfe/license \
  --query SecretString \
  --output text)"

encryption_password="$(aws secretsmanager get-secret-value \
  --secret-id tfe/encryption_password \
  --query SecretString \
  --output text)"

mkdir -p /etc/ssl/private/terraform-enterprise

openssl req -x509 \
  -nodes \
  -newkey rsa:4096 \
  -keyout /etc/ssl/private/terraform-enterprise/key.pem \
  -out /etc/ssl/private/terraform-enterprise/cert.pem \
  -sha256 -days 365 \
  -subj "/C=CA/O=HashiCorp/CN=${tfe_hostname}"

cp /etc/ssl/private/terraform-enterprise/cert.pem /etc/ssl/private/terraform-enterprise/bundle.pem

# Terraform Enterprise

mkdir -p /var/lib/terraform-enterprise

mkdir -p /run/terraform-enterprise

cat <<EOF >/run/terraform-enterprise/docker-compose.yml
---
name: terraform-enterprise
services:
  tfe:
    image: images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202311-1
    environment:
      TFE_LICENSE: "${hashicorp_license}"
      TFE_HOSTNAME: "${tfe_hostname}"
      TFE_ENCRYPTION_PASSWORD: "${encryption_password}"
      TFE_OPERATIONAL_MODE: "disk"
      TFE_DISK_CACHE_VOLUME_NAME: "terraform-enterprise-cache"
      TFE_TLS_CERT_FILE: "/etc/ssl/private/terraform-enterprise/cert.pem"
      TFE_TLS_KEY_FILE: "/etc/ssl/private/terraform-enterprise/key.pem"
      TFE_TLS_CA_BUNDLE_FILE: "/etc/ssl/private/terraform-enterprise/bundle.pem"
      TFE_IACT_SUBNETS: "10.0.0.0/16"
    cap_add:
      - IPC_LOCK
    read_only: true
    tmpfs:
      - /tmp:mode=01777
      - /run
      - /var/log/terraform-enterprise
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - type: bind
        source: /var/run/docker.sock
        target: /run/docker.sock
      - type: bind
        source: /etc/ssl/private/terraform-enterprise
        target: /etc/ssl/private/terraform-enterprise
      - type: bind
        source: /var/lib/terraform-enterprise
        target: /var/lib/terraform-enterprise
      - type: volume
        source: terraform-enterprise-cache
        target: /var/cache/tfe-task-worker/terraform
volumes:
  terraform-enterprise-cache:
EOF

echo "${hashicorp_license}" |
  docker login --username terraform images.releases.hashicorp.com --password-stdin

docker pull images.releases.hashicorp.com/hashicorp/terraform-enterprise:v202311-1

cat <<'EOF' >/etc/systemd/system/terraform-enterprise.service
[Unit]
Description=Terraform Enterprise Service
Requires=docker.service
After=docker.service network.target

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/run/terraform-enterprise
ExecStart=/usr/bin/docker compose up --detach
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now terraform-enterprise.service
