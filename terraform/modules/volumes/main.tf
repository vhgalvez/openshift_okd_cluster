# terraform\modules\volumes\main.tf

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

resource "libvirt_volume" "bootstrap" {
  name   = var.bootstrap["name"]
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

resource "libvirt_volume" "controlplane_1" {
  name   = var.controlplane_1["name"]
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

resource "libvirt_volume" "controlplane_2" {
  name   = var.controlplane_2["name"]
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

resource "libvirt_volume" "controlplane_3" {
  name   = var.controlplane_3["name"]
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

resource "libvirt_volume" "worker" {
  name   = var.worker["name"]
  pool   = "default"
  source = var.coreos_image
  format = "qcow2"
}

output "bootstrap_volume_id" {
  value = libvirt_volume.bootstrap.id
}

output "controlplane_1_volume_id" {
  value = libvirt_volume.controlplane_1.id
}

output "controlplane_2_volume_id" {
  value = libvirt_volume.controlplane_2.id
}

output "controlplane_3_volume_id" {
  value = libvirt_volume.controlplane_3.id
}

output "worker_volume_id" {
  value = libvirt_volume.worker.id
}
