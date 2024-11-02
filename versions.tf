terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.13.0"
    }
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.1.0"
    }
  }
}
