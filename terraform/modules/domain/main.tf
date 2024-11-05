# terraform/modules/domain/main.tfterraform {
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

  coreos_ignition = var.bootstrap_ignition_id

  graphics {
    type     = "vnc"
    autoport = true
  }
}

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

  coreos_ignition = var.master_ignition_id

  graphics {
    type     = "vnc"
    autoport = true
  }
}

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

  coreos_ignition = var.master_ignition_id

  graphics {
    type     = "vnc"
    autoport = true
  }
}

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

  coreos_ignition = var.master_ignition_id

  graphics {
    type     = "vnc"
    autoport = true
  }
}
