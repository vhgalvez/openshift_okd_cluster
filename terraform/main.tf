terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.1" // Ensure compatibility with cdrom and firmware blocks
    }
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.1.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "ignition" {
  source = "./modules/ignition"
}

module "network" {
  source         = "./modules/network"
  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
}

module "volumes" {
  source                     = "./modules/volumes"
  coreos_image               = var.coreos_image
  bootstrap_volume_size      = var.bootstrap.volume_size
  controlplane_1_volume_size = var.controlplane_1.volume_size
  controlplane_2_volume_size = var.controlplane_2.volume_size
  controlplane_3_volume_size = var.controlplane_3.volume_size
}

module "domain" {
  source     = "./modules/domain"
  network_id = module.network.okd_network.id

  bootstrap_volume_id = module.volumes.okd_bootstrap.id

  controlplane_1_volume_id = module.volumes.okd_controlplane_1.id
  controlplane_2_volume_id = module.volumes.okd_controlplane_2.id
  controlplane_3_volume_id = module.volumes.okd_controlplane_3.id

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3

  hostname_prefix = var.hostname_prefix

  controlplane_count = var.controlplane_count

  hosts = var.controlplane_count + 1 // Define the hosts variable

  bootstrap_ignition_id = module.ignition.bootstrap_ignition.id
  master_ignition_id    = module.ignition.master_ignition.id

  // depends_on = [
  //   module.network,
  //   module.volumes
  // ]
}
