terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.7.1, < 0.9.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
