terraform {
  required_version = "= 1.9.8"

  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.13.0"  # Versión estable del proveedor `ct`
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">= 0.8.1, < 0.9.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
