# terraform\modules\domain\variables.tf

# Existing variables
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

# Add missing ignition IDs for bootstrap and master
variable "bootstrap_ignition_id" {
  type        = string
  description = "Ignition ID for the bootstrap node"
}

variable "master_ignition_id" {
  type        = string
  description = "Ignition ID for the master/control plane nodes"
}

# VM details as maps
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
