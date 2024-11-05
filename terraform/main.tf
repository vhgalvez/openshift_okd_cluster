# terraform\main.tf

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# Módulo de red
module "network" {
  source         = "./modules/network"
  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
}

# Módulo de volúmenes
module "volumes" {
  source                     = "./modules/volumes"
  coreos_image               = var.coreos_image
  bootstrap_volume_size      = var.bootstrap.volume_size
  controlplane_1_volume_size = var.controlplane_1.volume_size
  controlplane_2_volume_size = var.controlplane_2.volume_size
  controlplane_3_volume_size = var.controlplane_3.volume_size
  network_id                 = module.network.okd_network_id
  bootstrap                  = var.bootstrap
  controlplane_1             = var.controlplane_1
  controlplane_2             = var.controlplane_2
  controlplane_3             = var.controlplane_3
}

# Módulo de Ignition
module "ignition" {
  source                     = "./modules/ignition"
  bootstrap                  = var.bootstrap
  controlplane_1             = var.controlplane_1
  controlplane_2             = var.controlplane_2
  controlplane_3             = var.controlplane_3
  bootstrap_volume_id        = module.volumes.okd_bootstrap_id
  controlplane_1_volume_id   = module.volumes.okd_controlplane_1_id
  controlplane_2_volume_id   = module.volumes.okd_controlplane_2_id
  controlplane_3_volume_id   = module.volumes.okd_controlplane_3_id
  network_id                 = module.network.okd_network_id
  mount_images_content       = file("./qemu-agent/docker-images.mount")
  qemu_agent_content         = file("./qemu-agent/qemu-agent.service")
  core_user_password_hash    = var.core_user_password_hash
  hosts                      = var.controlplane_count + 1
  hostname_prefix            = var.hostname_prefix
}

# Módulo de dominio
module "domain" {
  source                   = "./modules/domain"
  network_id               = module.network.okd_network_id
  bootstrap_volume_id      = module.volumes.okd_bootstrap_id
  controlplane_1_volume_id = module.volumes.okd_controlplane_1_id
  controlplane_2_volume_id = module.volumes.okd_controlplane_2_id
  controlplane_3_volume_id = module.volumes.okd_controlplane_3_id

  # Retrieve the Ignition IDs from the ignition module
  bootstrap_ignition_id    = module.ignition.bootstrap_ignition_id
  master_ignition_id       = module.ignition.master_ignition_id
  
  bootstrap                = var.bootstrap
  controlplane_1           = var.controlplane_1
  controlplane_2           = var.controlplane_2
  controlplane_3           = var.controlplane_3
}
