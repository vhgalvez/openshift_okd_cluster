# terraform\modules\domain\variables.tf
# Network ID for connecting the domains
variable "network_id" {
  type = string
}

# Volume IDs for each domain
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

# Domain configurations
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

# Ignition configurations
variable "bootstrap_ignition_id" {
  description = "ID del volumen Ignition para bootstrap"
  type        = string
}

variable "master_ignition_id" {
  description = "ID del volumen Ignition para los nodos master"
  type        = string
}
