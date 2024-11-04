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

data "ignition_systemd_unit" "mount_images" {
  name    = "docker-images.mount"
  enabled = true
  content = var.mount_images_content
}

data "ignition_systemd_unit" "qemu_agent" {
  name    = "qemu-agent.service"
  enabled = true
  content = var.qemu_agent_content
}

resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  source = "/mnt/lv_data/bootstrap.ign"
  format = "raw"

  provisioner "local-exec" {
    command = "while [ ! -f /mnt/lv_data/bootstrap.ign ]; do sleep 1; done"
  }
}

resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = "/mnt/lv_data/master.ign"
  format = "raw"

  provisioner "local-exec" {
    command = "while [ ! -f /mnt/lv_data/master.ign ]; do sleep 1; done"
  }
}
