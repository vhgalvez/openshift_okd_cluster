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

provider "ignition" {
  // Configuration options
}

resource "null_resource" "copy_ignition_files" {
  provisioner "local-exec" {
    command = "rm -f /mnt/lv_data/bootstrap.ign /mnt/lv_data/master.ign && cp ${path.module}/ignition_configs/bootstrap.ign /mnt/lv_data/ && cp ${path.module}/ignition_configs/master.ign /mnt/lv_data/"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

module "ignition" {
  source                  = "./modules/ignition"
  mount_images_content    = file("${path.module}/qemu-agent/var-lib-docker-images.mount")
  qemu_agent_content      = file("${path.module}/qemu-agent/qemu-agent.service")
  core_user_password_hash = "$6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/"
  hosts                   = var.controlplane_count + 1
  hostname_prefix         = var.hostname_prefix
  bootstrap_ignition_id   = var.bootstrap_ignition_id
  master_ignition_id      = var.master_ignition_id
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
  hosts                      = var.controlplane_count + 1
  hostname_prefix            = var.hostname_prefix
  bootstrap                  = var.bootstrap
  controlplane_1             = var.controlplane_1
  controlplane_2             = var.controlplane_2
  controlplane_3             = var.controlplane_3
  bootstrap_volume_id        = module.volumes.okd_bootstrap_id
  controlplane_1_volume_id   = module.volumes.okd_controlplane_1_id
  controlplane_2_volume_id   = module.volumes.okd_controlplane_2_id
  controlplane_3_volume_id   = module.volumes.okd_controlplane_3_id
  network_id                 = module.network.okd_network.id
  depends_on                 = [null_resource.copy_ignition_files] // Added dependency
}

module "domain" {
  source     = "./modules/domain"
  network_id = module.network.okd_network.id

  bootstrap_volume_id = module.volumes.okd_bootstrap_id

  controlplane_1_volume_id = module.volumes.okd_controlplane_1_id
  controlplane_2_volume_id = module.volumes.okd_controlplane_2_id
  controlplane_3_volume_id = module.volumes.okd_controlplane_3_id

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3

  hostname_prefix = var.hostname_prefix

  controlplane_count = var.controlplane_count

  hosts = var.controlplane_count + 1

  bootstrap_ignition_id = module.ignition.bootstrap_ignition
  master_ignition_id    = module.ignition.master_ignition
  core_user_password_hash = var.core_user_password_hash
  mount_images_content    = module.ignition.mount_images_content
  qemu_agent_content      = module.ignition.qemu_agent_content
}
