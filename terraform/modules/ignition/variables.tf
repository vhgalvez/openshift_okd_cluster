# modules/ignition/variables.tf

variable "bootstrap" {
  type = map(string)
  description = "Configuration map for the bootstrap node"
}

variable "controlplane_1" {
  type = map(string)
  description = "Configuration map for control plane node 1"
}

variable "controlplane_2" {
  type = map(string)
  description = "Configuration map for control plane node 2"
}

variable "controlplane_3" {
  type = map(string)
  description = "Configuration map for control plane node 3"
}

variable "bootstrap_volume_id" {
  type        = string
  description = "Volume ID for the bootstrap node"
}

variable "controlplane_1_volume_id" {
  type        = string
  description = "Volume ID for control plane node 1"
}

variable "controlplane_2_volume_id" {
  type        = string
  description = "Volume ID for control plane node 2"
}

variable "controlplane_3_volume_id" {
  type        = string
  description = "Volume ID for control plane node 3"
}

variable "network_id" {
  type        = string
  description = "Network ID for all nodes"
}

variable "core_user_password_hash" {
  type        = string
  description = "Password hash for the core user"
}

variable "mount_images_content" {
  type        = string
  description = "Content for mounting Docker images"
}

variable "qemu_agent_content" {
  type        = string
  description = "Content for the QEMU agent service"
}

variable "hosts" {
  type        = number
  description = "Number of hosts"
}

variable "hostname_prefix" {
  type        = string
  description = "Prefix for hostnames"
}
