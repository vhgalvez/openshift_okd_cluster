# terraform\main.tf

# terraform/main.tf

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.8.1"
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

# Proveedor de ignition
provider "ignition" {}

# Recurso para copiar archivos Ignition a la ubicación necesaria
resource "null_resource" "copy_ignition_files" {
  provisioner "local-exec" {
    command = "cp ${path.module}/ignition_configs/bootstrap.ign /mnt/lv_data/ && cp ${path.module}/ignition_configs/master.ign /mnt/lv_data/"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

# Definir el recurso libvirt_ignition para el archivo bootstrap
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "bootstrap.ign"
  content = file("/mnt/lv_data/bootstrap.ign")
  pool    = "default"
}

# Definir el recurso libvirt_ignition para el archivo master
resource "libvirt_ignition" "master_ignition" {
  name    = "master.ign"
  content = file("/mnt/lv_data/master.ign")
  pool    = "default"
}

# Módulo ignition para pasar configuración de servicios del sistema
module "ignition" {
  source                  = "./modules/ignition"
  mount_images_content    = file("/home/victory/openshift_okd_cluster/terraform/qemu-agent/docker-images.mount")
  qemu_agent_content      = file("/home/victory/openshift_okd_cluster/terraform/qemu-agent/qemu-agent.service")
  core_user_password_hash = var.core_user_password_hash
  hosts                   = var.controlplane_count + 1
  hostname_prefix         = var.hostname_prefix
}

# Módulo de red para la configuración de network
module "network" {
  source         = "./modules/network"
  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
}

# Módulo de volúmenes para crear volúmenes
module "volumes" {
  source                     = "./modules/volumes"
  coreos_image               = var.coreos_image
  bootstrap_volume_size      = var.bootstrap.volume_size
  controlplane_1_volume_size = var.controlplane_1.volume_size
  controlplane_2_volume_size = var.controlplane_2.volume_size
  controlplane_3_volume_size = var.controlplane_3.volume_size
  hosts                      = var.controlplane_count + 1
  hostname_prefix            = var.hostname_prefix
  network_id                 = module.network.okd_network.id
}

# Módulo de dominio, que utiliza los recursos Ignition
module "domain" {
  source     = "./modules/domain"
  network_id = module.network.okd_network.id

  # Asignación de volúmenes creados
  bootstrap_volume_id      = module.volumes.okd_bootstrap_id
  controlplane_1_volume_id = module.volumes.okd_controlplane_1_id
  controlplane_2_volume_id = module.volumes.okd_controlplane_2_id
  controlplane_3_volume_id = module.volumes.okd_controlplane_3_id

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3

  hostname_prefix    = var.hostname_prefix
  controlplane_count = var.controlplane_count
  hosts              = var.controlplane_count + 1

  # Asignación de Ignition IDs para bootstrap y master
  bootstrap_ignition_id   = libvirt_ignition.bootstrap_ignition.id
  master_ignition_id      = libvirt_ignition.master_ignition.id
  core_user_password_hash = var.core_user_password_hash
}
