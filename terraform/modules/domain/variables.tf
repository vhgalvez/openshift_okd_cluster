# modules/domain/variables.tf

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

variable "bootstrap_ignition" {
  type        = string
  description = "Base64-encoded Ignition content for the bootstrap node"
}

variable "master_ignition" {
  type        = string
  description = "Base64-encoded Ignition content for the master/control plane nodes"
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
