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

# Create the new directory if it does not exist and copy Ignition files to this alternative directory
resource "null_resource" "copy_ignition_files_alternative" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p /mnt/lv_data/ignition_alternativo
      cp ./ignition_configs/bootstrap.ign /mnt/lv_data/ignition_alternativo/bootstrap.iso
      cp ./ignition_configs/master.ign /mnt/lv_data/ignition_alternativo/master.iso
      cp ./ignition_configs/worker.ign /mnt/lv_data/ignition_alternativo/worker.iso
    EOT
  }

  # Use triggers to ensure this action always runs
  triggers = {
    always_run = timestamp()
  }
}

# Remove existing volumes if they are in conflict
resource "null_resource" "clean_up_existing_volumes" {
  provisioner "local-exec" {
    command = <<EOT
      virsh vol-list --pool default | grep 'bootstrap.ign' && virsh vol-delete --pool default bootstrap.ign || true
      virsh vol-list --pool default | grep 'master.ign' && virsh vol-delete --pool default master.ign || true
      virsh vol-list --pool default | grep 'worker.ign' && virsh vol-delete --pool default worker.ign || true
    EOT
  }
  depends_on = [null_resource.copy_ignition_files_alternative]
}

# Define data sources for Ignition files in the new directory
data "local_file" "bootstrap_ignition" {
  filename = "/mnt/lv_data/ignition_alternativo/bootstrap.iso"
  depends_on = [null_resource.copy_ignition_files_alternative]
}

data "local_file" "master_ignition" {
  filename = "/mnt/lv_data/ignition_alternativo/master.iso"
  depends_on = [null_resource.copy_ignition_files_alternative]
}

data "local_file" "worker_ignition" {
  filename = "/mnt/lv_data/ignition_alternativo/worker.iso"
  depends_on = [null_resource.copy_ignition_files_alternative]
}

# Create libvirt volumes for Ignition configurations from the new directory
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  source = data.local_file.bootstrap_ignition.filename
  format = "raw"
  depends_on = [null_resource.clean_up_existing_volumes]
}

resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = data.local_file.master_ignition.filename
  format = "raw"
  depends_on = [null_resource.clean_up_existing_volumes]
}

resource "libvirt_volume" "worker_ignition" {
  name   = "worker.ign"
  pool   = "default"
  source = data.local_file.worker_ignition.filename
  format = "raw"
  depends_on = [null_resource.clean_up_existing_volumes]
}

resource "libvirt_volume" "bootstrap" {
  name   = "bootstrap"
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

resource "libvirt_volume" "master" {
  name   = "master"
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

resource "libvirt_volume" "worker" {
  name   = "worker"
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

resource "libvirt_volume" "bootstrap_iso" {
  name   = "bootstrap-iso"
  pool   = "default"
  source = "/mnt/lv_data/ignition_alternativo/bootstrap.iso"
  format = "iso"
}

resource "libvirt_volume" "master_iso" {
  name   = "master-iso"
  pool   = "default"
  source = "/mnt/lv_data/ignition_alternativo/master.iso"
  format = "iso"
}

resource "libvirt_volume" "worker_iso" {
  name   = "worker-iso"
  pool   = "default"
  source = "/mnt/lv_data/ignition_alternativo/worker.iso"
  format = "iso"
}

resource "libvirt_ignition" "bootstrap_ign" {
  name    = "bootstrap.ign"
  pool    = "default"
  content = file("/mnt/lv_data/bootstrap.ign")
}

resource "libvirt_ignition" "master_ign" {
  name    = "master.ign"
  pool    = "default"
  content = file("/mnt/lv_data/master.ign")
}

resource "libvirt_ignition" "worker_ign" {
  name    = "worker.ign"
  pool    = "default"
  content = file("/mnt/lv_data/worker.ign")
}

resource "libvirt_domain" "bootstrap" {
  name       = "bootstrap"
  memory     = "2048"
  vcpu       = 2
  qemu_agent = true

  disk {
    volume_id = libvirt_volume.bootstrap.id
  }

  disk {
    volume_id = libvirt_volume.bootstrap_iso.id
  }

  network_interface {
    network_name = "default"
  }

  graphics {
    type     = "vnc"
    autoport = true
  }

  coreos_ignition = libvirt_ignition.bootstrap_ign.id
}

resource "libvirt_domain" "master" {
  name       = "master"
  memory     = "4096"
  vcpu       = 4
  qemu_agent = true

  disk {
    volume_id = libvirt_volume.master.id
  }

  disk {
    volume_id = libvirt_volume.master_iso.id
  }

  network_interface {
    network_name = "default"
  }

  graphics {
    type     = "vnc"
    autoport = true
  }

  coreos_ignition = libvirt_ignition.master_ign.id
}

resource "libvirt_domain" "worker" {
  name       = "worker"
  memory     = "4096"
  vcpu       = 4
  qemu_agent = true

  disk {
    volume_id = libvirt_volume.worker.id
  }

  disk {
    volume_id = libvirt_volume.worker_iso.id
  }

  network_interface {
    network_name = "default"
  }

  graphics {
    type     = "vnc"
    autoport = true
  }

  coreos_ignition = libvirt_ignition.worker_ign.id
}

# Módulo para la Red
module "network" {
  source = "./modules/network"

  bootstrap      = var.bootstrap
  controlplane_1 = var.controlplane_1
  controlplane_2 = var.controlplane_2
  controlplane_3 = var.controlplane_3
}

# Módulo para Volúmenes
module "volumes" {
  source = "./modules/volumes"

  coreos_image    = var.coreos_image
  bootstrap       = var.bootstrap
  controlplane_1  = var.controlplane_1
  controlplane_2  = var.controlplane_2
  controlplane_3  = var.controlplane_3
  worker          = var.worker
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

  bootstrap               = var.bootstrap
  controlplane_1          = var.controlplane_1
  controlplane_2          = var.controlplane_2
  controlplane_3          = var.controlplane_3
  worker                  = var.worker
  bootstrap_volume_id     = module.volumes.bootstrap_volume_id
  controlplane_1_volume_id = module.volumes.controlplane_1_volume_id
  controlplane_2_volume_id = module.volumes.controlplane_2_volume_id
  controlplane_3_volume_id = module.volumes.controlplane_3_volume_id
  worker_volume_id        = module.volumes.worker_volume_id
  network_id              = module.network.okd_network_id
  hosts                   = var.hosts
  hostname_prefix         = var.hostname_prefix
  core_user_password_hash = var.core_user_password_hash
  qemu_agent_content      = data.template_file.qemu_agent_service.rendered
  mount_images_content    = data.template_file.docker_images_mount.rendered
}

# Módulo para Dominios (Máquinas Virtuales)
module "domain" {
  source = "./modules/domain"

  volumes = {
    bootstrap      = module.volumes.bootstrap_volume_id
    controlplane_1 = module.volumes.controlplane_1_volume_id
    controlplane_2 = module.volumes.controlplane_2_volume_id
    controlplane_3 = module.volumes.controlplane_3_volume_id
    worker         = module.volumes.worker_volume_id
  }
  bootstrap          = var.bootstrap
  controlplane_1     = var.controlplane_1
  controlplane_2     = var.controlplane_2
  controlplane_3     = var.controlplane_3
  worker             = var.worker
  bootstrap_ignition = libvirt_volume.bootstrap_iso.id
  master_ignition    = libvirt_volume.master_iso.id
  worker_ignition    = libvirt_volume.worker_iso.id
}

