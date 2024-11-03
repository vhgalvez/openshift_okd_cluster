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

data "ignition_systemd_unit" "mount_images" {
  name    = "var-mnt-images.mount"
  enabled = true
  content = file("${path.module}/docker-images-mount/docker-images.mount")
}

data "ignition_systemd_unit" "qemu_agent" {
  name    = "qemu-agent.service"
  enabled = true
  content = file("${path.module}/docker-images-mount/qemu-agent.service")
}

module "ignition" {
  source                  = "./modules/ignition"
  mount_images_content    = data.ignition_systemd_unit.mount_images.rendered
  qemu_agent_content      = data.ignition_systemd_unit.qemu_agent.rendered
  core_user_password_hash = "$6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/"
  hosts                   = var.controlplane_count + 1
  hostname_prefix         = var.hostname_prefix
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

  bootstrap_ignition_id = module.ignition.bootstrap_ignition_id
  master_ignition_id    = module.ignition.master_ignition_id
}
