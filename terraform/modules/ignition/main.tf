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


# Data block for the Ignition configuration files
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  source = "/mnt/lv_data/bootstrap.ign"
  format = "raw"
}

resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = "/mnt/lv_data/master.ign"
  format = "raw"
}


# Resource for Bootstrap Node
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

  # Use the base64-encoded content from the data block
  coreos_ignition = base64encode(data.local_file.bootstrap_ignition.content)

  graphics {
    type     = "vnc"
    autoport = true
  }
}

# Resource for Control Plane Node 1
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

  # Use the base64-encoded content from the data block
  coreos_ignition = base64encode(data.local_file.master_ignition.content)

  graphics {
    type     = "vnc"
    autoport = true
  }
}

# Resource for Control Plane Node 2
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

  # Use the base64-encoded content from the data block
  coreos_ignition = base64encode(data.local_file.master_ignition.content)

  graphics {
    type     = "vnc"
    autoport = true
  }
}

# Resource for Control Plane Node 3
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

  # Use the base64-encoded content from the data block
  coreos_ignition = base64encode(data.local_file.master_ignition.content)

  graphics {
    type     = "vnc"
    autoport = true
  }
}
