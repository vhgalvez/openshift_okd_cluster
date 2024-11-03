# terraform\modules\ignition\main.tf
terraform {
  required_providers {
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.1.0"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

// Define volume for the bootstrap Ignition file
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "okd_bootstrap.ign"
  pool   = "default"
  source = var.bootstrap_ignition_id
}

// Define volume for the master Ignition file
resource "libvirt_volume" "master_ignition" {
  name   = "okd_master.ign"
  pool   = "default"
  source = var.master_ignition_id
  format = "raw"
}

data "ignition_systemd_unit" "mount_images" {
  name    = "var-mnt-images.mount"
  enabled = true
  content = <<EOF
[Unit]
Description=Mount Docker Images Directory
Before=local-fs.target

[Mount]
What=/srv/images
Where=/var/lib/docker-images
Type=none
Options=bind

[Install]
WantedBy=multi-user.target
EOF
}

data "ignition_systemd_unit" "qemu_agent" {
  name    = "qemu-agent.service"
  enabled = true
  content = <<EOF
[Unit]
Description=QEMU Guest Agent
After=docker.service
Requires=docker.service

[Service]
ExecStartPre=-/usr/bin/docker load -i /var/lib/docker-images/qemu-guest-agent.tar
ExecStart=/usr/bin/docker run --rm --name qemu-guest-agent rancher/os-qemuguestagent:v2.8.1-2
Restart=always

[Install]
WantedBy=multi-user.target
EOF
}

data "ignition_user" "core" {
  name          = "core"
  password_hash = var.core_user_password_hash
}

data "ignition_file" "hostname" {
  count = var.hosts
  path  = "/etc/hostname"

  content {
    content = "${var.hostname_prefix}${count.index + 1}"
  }
}

data "ignition_config" "startup" {
  count = var.hosts

  systemd = [
    data.ignition_systemd_unit.mount_images.rendered,
    data.ignition_systemd_unit.qemu_agent.rendered,
  ]
  users = [data.ignition_user.core.rendered]
  files = [data.ignition_file.hostname[count.index].rendered]
}

output "bootstrap_ignition" {
  value = libvirt_volume.bootstrap_ignition.id
}

output "master_ignition" {
  value = libvirt_volume.master_ignition.id
}
