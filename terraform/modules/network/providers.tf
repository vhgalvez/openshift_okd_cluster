terraform {
  required_version = "~>1.5"
}

provider "libvirt" {
  uri = "qemu:///system"
}
