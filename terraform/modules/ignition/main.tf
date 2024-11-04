# terraform/modules/ignition/main.tf

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
  name   = "bootstrap.ign"
  pool   = "default"
  source = "${path.module}/../../ignition_configs/bootstrap.ign"
  format = "raw"
}

// Define volume for the master Ignition file
resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = "${path.module}/../../ignition_configs/master.ign"
  format = "raw"
}

data "ignition_systemd_unit" "mount_images" {
  name    = "var-mnt-images.mount"
  enabled = true
  content = file("${path.module}/../../qemu-agent/docker-images.mount")
}

data "ignition_systemd_unit" "qemu_agent" {
  name    = "qemu-agent.service"
  enabled = true
  content = file("${path.module}/../../qemu-agent/qemu-agent.service")
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

output "mount_images_content" {
  value = data.ignition_systemd_unit.mount_images.rendered
}

output "qemu_agent_content" {
  value = data.ignition_systemd_unit.qemu_agent.rendered
}
