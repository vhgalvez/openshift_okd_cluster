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

# Módulo de Configuración Ignition
module "ignition" {
  source                   = "./modules/ignition"
}

# Módulo para Dominios (Máquinas Virtuales)
module "domain" {
  source                   = "./modules/domain"
  volumes = {
    bootstrap = module.volumes.bootstrap.id
    controlplane_1 = module.volumes.controlplane_1.id
    controlplane_2 = module.volumes.controlplane_2.id
    controlplane_3 = module.volumes.controlplane_3.id
  }
  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
  bootstrap_ignition = module.ignition.bootstrap_ignition_content
  master_ignition    = module.ignition.master_ignition_content
}

