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

# Create a unique temporary directory and copy Ignition files to this directory
resource "null_resource" "prepare_ignition_files" {
  provisioner "local-exec" {
    command = <<EOT
      TEMP_DIR=$(mktemp -d)
      mkdir -p $TEMP_DIR
      cp /mnt/lv_data/bootstrap.ign $TEMP_DIR/bootstrap.iso
      cp /mnt/lv_data/master.ign $TEMP_DIR/master.iso
      cp /mnt/lv_data/worker.ign $TEMP_DIR/worker.iso
      echo $TEMP_DIR > /tmp/ignition_dir
    EOT
  }

  # Use triggers to ensure this action always runs
  triggers = {
    always_run = timestamp()
  }
}

# Define data sources for Ignition files in the temporary directory
data "local_file" "bootstrap_ignition" {
  filename   = "${trimspace(file("/tmp/ignition_dir"))}/bootstrap.iso"
  depends_on = [null_resource.prepare_ignition_files]
}

data "local_file" "master_ignition" {
  filename   = "${trimspace(file("/tmp/ignition_dir"))}/master.iso"
  depends_on = [null_resource.prepare_ignition_files]
}

data "local_file" "worker_ignition" {
  filename   = "${trimspace(file("/tmp/ignition_dir"))}/worker.iso"
  depends_on = [null_resource.prepare_ignition_files]
}

# Create libvirt volumes for Ignition configurations from the temporary directory
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  source = data.local_file.bootstrap_ignition.filename
  format = "raw"

  lifecycle {
    create_before_destroy = true
  }
}

resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = data.local_file.master_ignition.filename
  format = "raw"

  lifecycle {
    create_before_destroy = true
  }
}

resource "libvirt_volume" "worker_ignition" {
  name   = "worker.ign"
  pool   = "default"
  source = data.local_file.worker_ignition.filename
  format = "raw"

  lifecycle {
    create_before_destroy = true
  }
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

# Clean up the temporary directory
resource "null_resource" "cleanup_temp_directory" {
  provisioner "local-exec" {
    command = "rm -rf $(cat /tmp/ignition_dir)"
  }
  depends_on = [libvirt_volume.bootstrap_ignition, libvirt_volume.master_ignition, libvirt_volume.worker_ignition]
}
