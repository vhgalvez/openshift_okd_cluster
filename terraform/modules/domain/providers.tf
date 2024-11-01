terraform {
  required_version = "= 1.9.8"

  required_providers {
    ignition = {
      source  = "terraform-providers/ignition"
      version = "~> 0.6.3" # Utiliza una versión estable de la serie 0.6.x
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

provider "libvirt" {
  uri = "qemu:///system"
}
