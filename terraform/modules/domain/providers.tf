terraform {
  required_version = "= 1.9.8"

  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.13.0"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.8.0, < 0.9.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}
