terraform {
  required_version = ">= 0.13"

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
    ignition = {
      source  = "terraform-providers/ignition"
      version = "~> 2.1.0"
    }
  }
}
