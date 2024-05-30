#!/usr/bin/env bash

set -euo pipefail

# The default username assigned to UID 1000 in AWS EC2 instances.
USERNAME="admin"

# Wait for the network to be available.
while ! ping -c 1 -W 1 8.8.8.8; do
  echo "Waiting for network..."
  sleep 1
done

# Update the system and install required utilities.
DEBIAN_FRONTEND=noninteractive apt-get -yq update
DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade
DEBIAN_FRONTEND=noninteractive apt-get -yq install apt-transport-https ca-certificates curl gnupg jq

# Convenience function to grab configuration from the SSM Parameter Store.
grab_ssm_parameter() {
  aws ssm get-parameter \
    --name "${1}" \
    --query "Parameter.Value" \
    --with-decryption \
    --output text
}

# Grab Configuration Parameters

postgresql_major_version="$(grab_ssm_parameter "/TFE/PostgreSQL-Major-Version")"
rds_fqdn="$(grab_ssm_parameter "/TFE/RDS-FQDN")"
s3_region="$(grab_ssm_parameter "/TFE/S3-Region")"
s3_bucket_id="$(grab_ssm_parameter "/TFE/S3-Bucket-ID")"
tfe_db_name="$(grab_ssm_parameter "/TFE/DB-Name")"
tfe_db_username="$(grab_ssm_parameter "/TFE/DB-Username")"
tfe_db_password="$(grab_ssm_parameter "/TFE/DB-Password")"
tfe_encryption_password="$(grab_ssm_parameter "/TFE/Encryption-Password")"
tfe_fqdn="$(grab_ssm_parameter "/TFE/TFE-FQDN")"
tfe_license="$(grab_ssm_parameter "/TFE/License")"
tfe_version="$(grab_ssm_parameter "/TFE/Version")"

# PostgreSQL

# Setup Postgres' apt repository.
curl -fsSL "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | gpg --yes --dearmor -o "/usr/share/keyrings/postgresql.gpg"

chmod a+r /usr/share/keyrings/postgresql.gpg

cat <<'EOF' >/etc/apt/sources.list.d/postgresql.sources
Types: deb
URIs: https://apt.postgresql.org/pub/repos/apt
Suites: bookworm-pgdg
Components: main
arch: amd64
signed-by: /usr/share/keyrings/postgresql.gpg
EOF

# Setup the RDS Instance for Terraform Enterprise

# Install the PostgreSQL CLI tool.
DEBIAN_FRONTEND=noninteractive apt-get -yq update
DEBIAN_FRONTEND=noninteractive apt-get -yq install "postgresql-client-${postgresql_major_version}"

# Grab the RDS credentials and configuration.

set +H # Temporarily disable history expansion, preventing the exclamation mark from being interpreted as a special character.
rds_master_password_secret="$(aws secretsmanager list-secrets --query "SecretList[?starts_with(Name, 'rds!')].Name" --output text)"
set -H # Re-enable history expansion.

rds_master_username="$(
  aws secretsmanager get-secret-value \
    --secret-id "${rds_master_password_secret}" \
    --query SecretString --output text |
    jq -r '.username'
)"

rds_master_password="$(
  aws secretsmanager get-secret-value \
    --secret-id "${rds_master_password_secret}" \
    --query SecretString --output text |
    jq -r '.password'
)"

# Check the version of PostgreSQL
check_postgresql_version="$(
  cat <<EOF
SHOW server_version;
EOF
)"

# Create a regular user for Terraform Enterprise.
create_user="$(
  cat <<EOF
CREATE USER ${tfe_db_username} WITH PASSWORD '${tfe_db_password}';
EOF
)"

# Give the regular access full access to the Terraform Enterprise database.
grant_all_privileges="$(
  cat <<EOF
GRANT ALL PRIVILEGES ON DATABASE ${tfe_db_name} TO ${tfe_db_username};
EOF
)"

# Set the owner of the Terraform Enterprise database to the regular user.
alter_database_owner="$(
  cat <<EOF
ALTER DATABASE ${tfe_db_name} OWNER TO ${tfe_db_username};
EOF
)"

# Convenience function to execute SQL queries against the RDS instance.
execute_sql() {
  PGPASSWORD="${rds_master_password}" psql \
    -h "${rds_fqdn}" \
    -p 5432 \
    -U "${rds_master_username}" \
    -d "${tfe_db_name}" \
    -c "${1}" \
    >/dev/null 2>&1
}

# Wait for the database to be available.
while ! execute_sql "${check_postgresql_version}" >/dev/null 2>&1; do
  echo "Waiting for the RDS database to come online..."
  sleep 1
done

# Apply the changes.
execute_sql "${create_user}" || true
execute_sql "${grant_all_privileges}" || true
execute_sql "${alter_database_owner}" || true

# Docker

# Setup Docker's apt repository.
curl -fsSL "https://download.docker.com/linux/debian/gpg" | gpg --yes --dearmor -o "/usr/share/keyrings/docker.gpg"

chmod a+r /usr/share/keyrings/docker.gpg

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

mkdir -p /etc/ssl/private/terraform-enterprise

if [ ! -f "/etc/ssl/private/terraform-enterprise/cert.pem" ]; then
  openssl req -x509 \
    -nodes \
    -newkey rsa:4096 \
    -keyout /etc/ssl/private/terraform-enterprise/key.pem \
    -out /etc/ssl/private/terraform-enterprise/cert.pem \
    -sha256 -days 365 \
    -subj "/C=CA/O=HashiCorp/CN=${tfe_fqdn}"
fi

cp /etc/ssl/private/terraform-enterprise/cert.pem /etc/ssl/private/terraform-enterprise/bundle.pem

# Terraform Enterprise

# Set the `http-put-response-hop-limit` option to a value of 2 or greater.
aws_token="$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")"
ec2_instance_id="$(curl -H "X-aws-ec2-metadata-token: ${aws_token}" -v http://169.254.169.254/latest/meta-data/instance-id)"

aws ec2 modify-instance-metadata-options \
  --instance-id "${ec2_instance_id}" \
  --http-tokens required \
  --http-endpoint enabled \
  --http-put-response-hop-limit 2

mkdir -p /var/lib/terraform-enterprise
mkdir -p /run/terraform-enterprise

cat <<EOF >/run/terraform-enterprise/docker-compose.yml
---
name: terraform-enterprise
services:
  tfe:
    image: "images.releases.hashicorp.com/hashicorp/terraform-enterprise:${tfe_version}"
    environment:
      TFE_LICENSE: "${tfe_license}"
      TFE_HOSTNAME: "${tfe_fqdn}"
      TFE_ENCRYPTION_PASSWORD: "${tfe_encryption_password}"
      TFE_OPERATIONAL_MODE: "external"
      TFE_DISK_CACHE_VOLUME_NAME: "terraform-enterprise-cache"
      TFE_TLS_CERT_FILE: "/etc/ssl/private/terraform-enterprise/cert.pem"
      TFE_TLS_KEY_FILE: "/etc/ssl/private/terraform-enterprise/key.pem"
      TFE_TLS_CA_BUNDLE_FILE: "/etc/ssl/private/terraform-enterprise/bundle.pem"
      TFE_IACT_SUBNETS: "10.0.0.0/16"
      # Database
      TFE_DATABASE_HOST: "${rds_fqdn}"
      TFE_DATABASE_NAME: "${tfe_db_name}"
      TFE_DATABASE_USER: "${tfe_db_username}"
      TFE_DATABASE_PASSWORD: "${tfe_db_password}"
      # Object Storage
      TFE_OBJECT_STORAGE_TYPE: "s3"
      TFE_OBJECT_STORAGE_S3_USE_INSTANCE_PROFILE: "true"
      TFE_OBJECT_STORAGE_S3_REGION: "${s3_region}"
      TFE_OBJECT_STORAGE_S3_BUCKET: "${s3_bucket_id}"
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

echo "${tfe_license}" |
  docker login --username terraform images.releases.hashicorp.com --password-stdin

docker pull "images.releases.hashicorp.com/hashicorp/terraform-enterprise:${tfe_version}"

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
