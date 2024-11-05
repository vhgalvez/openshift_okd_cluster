# terraform/modules/ignition/main.tf

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
resource "null_resource" "copy_ignition_files" {
  provisioner "local-exec" {
    command = "cp -r ./ignition_configs/bootstrap.ign /mnt/lv_data/ && cp -r ./ignition_configs/master.ign /mnt/lv_data/"
  }

  triggers = {
    always_run = timestamp()
  }
}

# Define data sources for Ignition files
data "local_file" "bootstrap_ignition" {
  filename = "/mnt/lv_data/bootstrap.ign"
}

data "local_file" "master_ignition" {
  filename = "/mnt/lv_data/master.ign"
}

# Create libvirt volumes for Ignition configurations
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  source = data.local_file.bootstrap_ignition.filename
  format = "raw"
}

resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = data.local_file.master_ignition.filename
  format = "raw"
}

# Output Ignition volume IDs
output "bootstrap_ignition_id" {
  value = libvirt_volume.bootstrap_ignition.id
}

output "master_ignition_id" {
  value = libvirt_volume.master_ignition.id
}
