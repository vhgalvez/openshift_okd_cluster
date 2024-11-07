terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.12"
    }
    ignition = {
      source = "community-terraform-providers/ignition"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

variable "libvirt_pool" {
  default = "default"  // Change this if your storage pool has a different name
}

variable "bootstrap_memory" {
  default = 4096  // Adjust as needed
}

variable "bootstrap_vcpu" {
  default = 2
}

variable "master_memory" {
  default = 8192  // Adjust as needed
}

variable "master_vcpu" {
  default = 4
}

variable "worker_memory" {
  default = 8192  // Adjust as needed
}

variable "worker_vcpu" {
  default = 4
}

variable "hostname_format" {
  type    = string
  default = "coreos%02d"
}

resource "libvirt_volume" "coreos-disk" {
  name             = "${format(var.hostname_format, count.index + 1)}.qcow2"
  count            = 3
  source           = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2"  // Correct path to the CoreOS image
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

