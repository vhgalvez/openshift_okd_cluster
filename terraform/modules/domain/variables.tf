# terraform\modules\domain\variables.tf
variable "network_id" {
  type = string
}

variable "bootstrap_volume_id" {
  type = string
}

variable "controlplane_1_volume_id" {
  type = string
}

variable "controlplane_2_volume_id" {
  type = string
}

variable "controlplane_3_volume_id" {
  type = string
}

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

variable "hostname_prefix" {
  type = string
}

variable "controlplane_count" {
  type = number
}

variable "hosts" {
  type        = number
  description = "Number of hosts"
}

variable "bootstrap_ignition_id" {
  type = string
}

variable "master_ignition_id" {
  type = string
}

variable "core_user_password_hash" {
  type = string
}

variable "mount_images_content" {
  type = string
}

variable "qemu_agent_content" {
  type = string
}
variable "bootstrap_volume_id" {
  type = string
}

variable "controlplane_1_volume_id" {
  type = string
}

variable "controlplane_2_volume_id" {
  type = string
}

variable "controlplane_3_volume_id" {
  type = string
}
