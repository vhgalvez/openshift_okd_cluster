# terraform/variables.tf

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
    vcpu        = 5
    memory      = 9  // GiB
    volume_size = 40 // GiB
    address     = "192.168.150.3"
    mac         = "AA:BB:CC:10:00:00"
  }
}

variable "controlplane_1" {
  type = map(string)
  default = {
    name        = "okd-controlplane-1"
    description = "okd controlplane 1 vm"
    vcpu        = 6
    memory      = 16  // GiB
    volume_size = 120 // GiB
    address     = "192.168.150.10"
    mac         = "AA:BB:CC:20:00:00"
  }
}

variable "controlplane_2" {
  type = map(string)
  default = {
    name        = "okd-controlplane-2"
    description = "okd controlplane 2 vm"
    vcpu        = 3
    memory      = 3  // GiB
    volume_size = 20 // GiB
    address     = "192.168.150.11"
    mac         = "AA:BB:CC:20:00:01"
  }
}

variable "controlplane_3" {
  type = map(string)
  default = {
    name        = "okd-controlplane-3"
    description = "okd controlplane 3 vm"
    vcpu        = 3
    memory      = 3  // GiB
    volume_size = 20 // GiB
    address     = "192.168.150.12"
    mac         = "AA:BB:CC:20:00:02"
  }
}

variable "worker" {
  type = map(string)
  default = {
    name        = "okd-worker"
    description = "okd worker vm"
    vcpu        = 4
    memory      = 8  // GiB
    volume_size = 40 // GiB
    address     = "192.168.150.20"
    mac         = "AA:BB:CC:30:00:00"
  }
}

variable "hosts" {
  type        = number
  description = "Number of hosts"
  default     = 3
}

variable "hostname_prefix" {
  type        = string
  description = "Prefix for hostnames"
  default     = "okd-node-"
}

variable "controlplane_count" {
  type        = number
  description = "Number of control planes"
  default     = 3
}

variable "core_user_password_hash" {
  type    = string
  default = "$6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/"
}
