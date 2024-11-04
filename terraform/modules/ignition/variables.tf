# terraform\modules\ignition\variables.tf
variable "hosts" {
  type = number
}

variable "hostname_prefix" {
  type = string
}

variable "mount_images_content" {
  type = string
}

variable "qemu_agent_content" {
  type = string
}

variable "core_user_password_hash" {
  type = string
}

variable "bootstrap_ignition_id" {
  type = string
}

variable "master_ignition_id" {
  type = string
}
