terraform {
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

// Recurso para el nodo bootstrap
resource "libvirt_domain" "okd_bootstrap" {
  name       = var.bootstrap["name"]
  memory     = var.bootstrap["memory"] * 1024
  vcpu       = var.bootstrap["vcpu"]
  qemu_agent = true

  disk {
    volume_id = var.volumes["bootstrap"]
  }

  network_interface {
    network_name = "okd_network"
    addresses    = [var.bootstrap["address"]]
    mac          = var.bootstrap["mac"]
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.bootstrap["name"])
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  coreos_ignition = var.bootstrap_ignition

  graphics {
    type     = "vnc"
    autoport = true
  }
}

// Recurso para el nodo de control plane 1
resource "libvirt_domain" "okd_controlplane_1" {
  name       = var.controlplane_1["name"]
  memory     = var.controlplane_1["memory"] * 1024
  vcpu       = var.controlplane_1["vcpu"]
  qemu_agent = true

  disk {
    volume_id = var.volumes["controlplane_1"]
  }

  network_interface {
    network_name = "okd_network"
    addresses    = [var.controlplane_1["address"]]
    mac          = var.controlplane_1["mac"]
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_1["name"])
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  coreos_ignition = var.master_ignition

  graphics {
    type     = "vnc"
    autoport = true
  }
}

// Recurso para el nodo de control plane 2
resource "libvirt_domain" "okd_controlplane_2" {
  name       = var.controlplane_2["name"]
  memory     = var.controlplane_2["memory"] * 1024
  vcpu       = var.controlplane_2["vcpu"]
  qemu_agent = true

  disk {
    volume_id = var.volumes["controlplane_2"]
  }

  network_interface {
    network_name = "okd_network"
    addresses    = [var.controlplane_2["address"]]
    mac          = var.controlplane_2["mac"]
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_2["name"])
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"]
  }

  coreos_ignition = var.master_ignition

  graphics {
    type     = "vnc"
    autoport = true
  }
}

// Recurso para el nodo de control plane 3
resource "libvirt_domain" "okd_controlplane_3" {
  name       = var.controlplane_3["name"]
  memory     = var.controlplane_3["memory"] * 1024
  vcpu       = var.controlplane_3["vcpu"]
  qemu_agent = true

  disk {
    volume_id = var.volumes["controlplane_3"]
  }

  network_interface {
    network_name = "okd_network"
    addresses    = [var.controlplane_3["address"]]
    mac          = var.controlplane_3["mac"]
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_3["name"])
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"]
  }

  coreos_ignition = var.master_ignition

  graphics {
    type     = "vnc"
    autoport = true
  }
}

// Recurso para el nodo worker
resource "libvirt_domain" "okd_worker" {
  name       = var.worker["name"]
  memory     = var.worker["memory"] * 1024
  vcpu       = var.worker["vcpu"]
  qemu_agent = true

  disk {
    volume_id = var.volumes["worker"]
  }

  network_interface {
    network_name = "okd_network"
    addresses    = [var.worker["address"]]
    mac          = var.worker["mac"]
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.worker["name"])
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"]
  }

  coreos_ignition = var.worker_ignition

  graphics {
    type     = "vnc"
    autoport = true
  }
}
