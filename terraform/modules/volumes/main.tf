# terraform\modules\volumes\main.tf

terraform {
  required_version = ">= 0.13"
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

variable "hostname_format" {
  type    = string
  default = "coreos%02d"
}

resource "libvirt_volume" "coreos-disk" {
  name             = "${format(var.hostname_format, count.index + 1)}.qcow2"
  count            = 3
  base_volume_name = "coreos_production_qemu"
  pool             = "default"
  format           = "qcow2"
}

resource "libvirt_ignition" "ignition_bootstrap" {
  name    = "bootstrap-ignition"
  pool    = "default"
  content = file("/mnt/lv_data/bootstrap.ign")
}

resource "libvirt_ignition" "ignition_master" {
  name    = "master-ignition"
  pool    = "default"
  content = file("/mnt/lv_data/master.ign")
}

resource "libvirt_ignition" "ignition_worker" {
  name    = "worker-ignition"
  pool    = "default"
  content = file("/mnt/lv_data/worker.ign")
}

resource "libvirt_domain" "coreos_machine" {
  count  = 3
  name   = format(var.hostname_format, count.index + 1)
  vcpu   = "2"
  memory = "4096"

  coreos_ignition = element([libvirt_ignition.ignition_bootstrap.id, libvirt_ignition.ignition_master.id, libvirt_ignition.ignition_worker.id], count.index)

  disk {
    volume_id = element(libvirt_volume.coreos-disk.*.id, count.index)
  }

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  graphics {
    listen_type = "address"
  }
}

output "ipv4" {
  value = libvirt_domain.coreos_machine.*.network_interface.0.addresses
}
