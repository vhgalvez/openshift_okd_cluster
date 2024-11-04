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

resource "libvirt_volume" "bootstrap_ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  source = "/mnt/lv_data/bootstrap.ign"
  format = "raw"

  provisioner "local-exec" {
    command = "test -f /mnt/lv_data/bootstrap.ign"
    when    = create
  }

  lifecycle {
    replace_triggered_by = [var.ignition_files_ready]
  }
}

resource "libvirt_volume" "master_ignition" {
  name   = "master.ign"
  pool   = "default"
  source = "/mnt/lv_data/master.ign"
  format = "raw"

  provisioner "local-exec" {
    command = "test -f /mnt/lv_data/master.ign"
    when    = create
  }

  lifecycle {
    replace_triggered_by = [var.ignition_files_ready]
  }
}
