# modules/ignition/main.tf

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

# Copy Ignition files to target directory
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

# Define data sources for Ignition files in the new directory
data "local_file" "bootstrap_ignition" {
  filename = "/mnt/lv_data/ignition_alternativo/bootstrap.iso"
}

data "local_file" "master_ignition" {
  filename = "/mnt/lv_data/ignition_alternativo/master.iso"
}

data "local_file" "worker_ignition" {
  filename = "/mnt/lv_data/ignition_alternativo/worker.iso"
}

# Create libvirt volumes for Ignition configurations from the new directory
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  source = data.local_file.bootstrap_ignition.filename
  format = "raw"
  depends_on = [null_resource.copy_ignition_files_alternative]
}

resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = data.local_file.master_ignition.filename
  format = "raw"
  depends_on = [null_resource.copy_ignition_files_alternative]
}

resource "libvirt_volume" "worker_ignition" {
  name   = "worker.ign"
  pool   = "default"
  source = data.local_file.worker_ignition.filename
  format = "raw"
  depends_on = [null_resource.copy_ignition_files_alternative]
}

# Output the IDs of the Ignition volumes
output "bootstrap_ignition_content" {
  value = libvirt_volume.bootstrap_ignition.id
}

output "worker_ignition_content" {
  value = libvirt_volume.worker_ignition.id
}

output "master_ignition_content" {
  value = libvirt_volume.master_ignition.id
}
