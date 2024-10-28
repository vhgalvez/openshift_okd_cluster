variable "coreos_image" {
  type        = string
  default     = "/mnt/lv_data/organized_storage/images/fedora-coreos-40.20240906.3.0-qemu.x86_64.qcow2"
  description = "CoreOS image to use"
}

variable "bootstrap" {
  type = map(string)
  default = {
    name        = "okd-bootstrap"
    description = "okd bootstrap vm"
    vcpu        = 4
    memory      = 8  # GiB
    volume_size = 55 # GiB
    address     = "10.17.3.3"
    mac         = "AA:BB:CC:10:00:00"
  }
}

variable "controlplane_1" {
  type = map(string)
  default = {
    name        = "okd-controlplane-1"
    description = "okd controlplane 1 vm"
    vcpu        = 4
    memory      = 8  # GiB
    volume_size = 55 # GiB
    address     = "10.17.3.10"
    mac         = "AA:BB:CC:20:00:00"
  }
}

variable "controlplane_2" {
  type = map(string)
  default = {
    name        = "okd-controlplane-2"
    description = "okd controlplane 2 vm"
    vcpu        = 4
    memory      = 8  # GiB
    volume_size = 55 # GiB
    address     = "10.17.3.11"
    mac         = "AA:BB:CC:20:00:01"
  }
}

variable "controlplane_3" {
  type = map(string)
  default = {
    name        = "okd-controlplane-3"
    description = "okd controlplane 3 vm"
    vcpu        = 4
    memory      = 8  # GiB
    volume_size = 55 # GiB
    address     = "10.17.3.12"
    mac         = "AA:BB:CC:20:00:02"
  }
}
