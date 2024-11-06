# main.tf

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

# Módulo para la Red
module "network" {
  source         = "./modules/network"
  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
}

# Módulo para Volúmenes
module "volumes" {
  source                     = "./modules/volumes"
  coreos_image               = var.coreos_image
  bootstrap                  = var.bootstrap
  controlplane_1             = var.controlplane_1
  controlplane_2             = var.controlplane_2
  controlplane_3             = var.controlplane_3
}

data "template_file" "docker_images_mount" {
  template = file("${path.module}/qemu-agent/docker-images.mount")
}

data "template_file" "qemu_agent_service" {
  template = file("${path.module}/qemu-agent/qemu-agent.service")
}

# Módulo de Configuración Ignition
module "ignition" {
  source = "./modules/ignition"
  bootstrap = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  bootstrap_volume_id = module.volumes.bootstrap_volume_id
  controlplane_1_volume_id = module.volumes.controlplane_1_volume_id
  controlplane_2_volume_id = module.volumes.controlplane_2_volume_id
  controlplane_3_volume_id = module.volumes.controlplane_3_volume_id
  network_id = module.network.okd_network_id
  core_user_password_hash = var.core_user_password_hash
  hostname_prefix = var.hostname_prefix
  hosts = var.hosts
  mount_images_content = data.template_file.docker_images_mount.rendered
  qemu_agent_content = data.template_file.qemu_agent_service.rendered
}

# Módulo para Dominios (Máquinas Virtuales)
module "domain" {
  source                   = "./modules/domain"
  volumes = {
    bootstrap = module.volumes.bootstrap_volume_id
    controlplane_1 = module.volumes.controlplane_1_volume_id
    controlplane_2 = module.volumes.controlplane_2_volume_id
    controlplane_3 = module.volumes.controlplane_3_volume_id
  }
  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  bootstrap_ignition = module.ignition.bootstrap_ignition_content
  master_ignition    = module.ignition.master_ignition_content
  
}

