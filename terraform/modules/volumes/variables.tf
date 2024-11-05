# terraform\modules\volumes\variables.tf
variable "coreos_image" {
  type        = string
  description = "CoreOS image to use"
  default     = "/mnt/lv_data/organized_storage/images/fedora-coreos-39.20231101.3.0-qemu.x86_64.qcow2"
}

variable "bootstrap_volume_size" {
  type        = number
  description = "Size of the bootstrap volume in GiB"
}

variable "controlplane_1_volume_size" {
  type        = number
  description = "Size of controlplane 1 volume in GiB"
}

variable "controlplane_2_volume_size" {
  type        = number
  description = "Size of controlplane 2 volume in GiB"
}

variable "controlplane_3_volume_size" {
  type        = number
  description = "Size of controlplane 3 volume in GiB"
}

variable "network_id" {
  type = string
}

# Optional instance-specific mappings, if required by other resources
variable "bootstrap" {
  type = map(any)
}

variable "controlplane_1" {
  type = map(any)
}

variable "controlplane_2" {
  type = map(any)
}

variable "controlplane_3" {
  type = map(any)
}
