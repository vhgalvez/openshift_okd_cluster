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

provider "ignition" {
  // Configuration options
}

provider "libvirt" {
  // Configuration options
}

# size = convert GiB to Bytes
resource "libvirt_volume" "fedora_coreos" {
  name   = "fedora_coreos.qcow2"
  pool   = "default"
  source = var.coreos_image
}

resource "libvirt_volume" "okd_bootstrap" {
  name           = "okd_bootstrap.qcow2"
  pool           = "default"
  size           = var.bootstrap_volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "okd_controlplane_1" {
  name           = "okd_controlplane_1.qcow2"
  pool           = "default"
  size           = var.controlplane_1_volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "okd_controlplane_2" {
  name           = "okd_controlplane_2.qcow2"
  pool           = "default"
  size           = var.controlplane_2_volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}

resource "libvirt_volume" "okd_controlplane_3" {
  name           = "okd_controlplane_3.qcow2"
  pool           = "default"
  size           = var.controlplane_3_volume_size * 1073741824
  base_volume_id = libvirt_volume.fedora_coreos.id
}
