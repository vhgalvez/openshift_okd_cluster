# terraform/modules/domain/main.tf
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

# Ignition para el archivo bootstrap

resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "bootstrap.ign"
  content = var.bootstrap_ignition_content
}

resource "libvirt_ignition" "master_ignition" {
  name    = "master.ign"
  content = var.master_ignition_content
}

# Definir el recurso libvirt_ignition para el archivo bootstrap
resource "libvirt_domain" "okd_bootstrap" {
  name       = var.bootstrap.name
  memory     = var.bootstrap.memory * 1024
  vcpu       = var.bootstrap.vcpu
  qemu_agent = true

  disk {
    volume_id = var.bootstrap_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.bootstrap.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.bootstrap.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  # Referencia al recurso ignition para el archivo bootstrap
  coreos_ignition = libvirt_ignition.bootstrap_ignition.id

  graphics {
    type     = "vnc"
    autoport = true
  }
}

# Configuración del recurso libvirt_domain para okd_controlplane_1
resource "libvirt_domain" "okd_controlplane_1" {
  name       = var.controlplane_1.name
  memory     = var.controlplane_1.memory * 1024
  vcpu       = var.controlplane_1.vcpu
  qemu_agent = true

  disk {
    volume_id = var.controlplane_1_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.controlplane_1.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_1.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  # Referencia al recurso ignition para el archivo master
  coreos_ignition = libvirt_ignition.master_ignition.id

  graphics {
    type     = "vnc"
    autoport = true
  }
}

# Configuración del recurso libvirt_domain para okd_controlplane_2
resource "libvirt_domain" "okd_controlplane_2" {
  name       = var.controlplane_2.name
  memory     = var.controlplane_2.memory * 1024
  vcpu       = var.controlplane_2.vcpu
  qemu_agent = true

  disk {
    volume_id = var.controlplane_2_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.controlplane_2.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_2.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  # Referencia al recurso ignition para el archivo master
  coreos_ignition = libvirt_ignition.master_ignition.id

  graphics {
    type     = "vnc"
    autoport = true
  }
}

# Configuración del recurso libvirt_domain para okd_controlplane_3
resource "libvirt_domain" "okd_controlplane_3" {
  name       = var.controlplane_3.name
  memory     = var.controlplane_3.memory * 1024
  vcpu       = var.controlplane_3.vcpu
  qemu_agent = true

  disk {
    volume_id = var.controlplane_3_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.controlplane_3.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file     = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_3.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  # Referencia al recurso ignition para el archivo master
  coreos_ignition = libvirt_ignition.master_ignition.id

  graphics {
    type     = "vnc"
    autoport = true
  }
}
