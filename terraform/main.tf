terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
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

# Bootstrap node
resource "libvirt_domain" "bootstrap" {
  name   = "bootstrap"
  memory = var.bootstrap_memory
  vcpu   = var.bootstrap_vcpu

  coreos_ignition = file("/mnt/lv_data/bootstrap.ign")  // Path to your Ignition file

  disk {
    volume_id = libvirt_volume.bootstrap_disk.id
  }

  network_interface {
    network_name = "default"
  }

  graphics {
    listen_type = "none"
  }
}

resource "libvirt_volume" "bootstrap_disk" {
  name   = "bootstrap.qcow2"
  pool   = var.libvirt_pool
  source = var.coreos_image  // Path to the Fedora CoreOS base image
  format = "qcow2"
}

# Master nodes
resource "libvirt_domain" "master" {
  count  = 3  // Change this number according to the number of master nodes you need
  name   = "master-${count.index + 1}"
  memory = var.master_memory
  vcpu   = var.master_vcpu

  coreos_ignition = file("/mnt/lv_data/master.ign")

  disk {
    volume_id = libvirt_volume.master_disk[count.index].id
  }

  network_interface {
    network_name = "default"
  }

  graphics {
    listen_type = "none"
  }
}

resource "libvirt_volume" "master_disk" {
  count  = 3
  name   = "master-${count.index + 1}.qcow2"
  pool   = var.libvirt_pool
  source = var.coreos_image
  format = "qcow2"
}

# Worker nodes
resource "libvirt_domain" "worker" {
  count  = 2  // Change this number according to the number of worker nodes you need
  name   = "worker-${count.index + 1}"
  memory = var.worker_memory
  vcpu   = var.worker_vcpu

  coreos_ignition = file("/mnt/lv_data/worker.ign")

  disk {
    volume_id = libvirt_volume.worker_disk[count.index].id
  }

  network_interface {
    network_name = "default"
  }

  graphics {
    listen_type = "none"
  }
}

resource "libvirt_volume" "worker_disk" {
  count  = 2
  name   = "worker-${count.index + 1}.qcow2"
  pool   = var.libvirt_pool
  source = var.coreos_image
  format = "qcow2"
}

# Output the IPs of the nodes
output "bootstrap_ip" {
  value = libvirt_domain.bootstrap.network_interface.0.addresses
}

output "master_ips" {
  value = libvirt_domain.master[*].network_interface.0.addresses
}

output "worker_ips" {
  value = libvirt_domain.worker[*].network_interface.0.addresses
}

