# modules/domain/variables.tf
variable "volumes" {
  description = "Map of volume IDs for each domain"
  type        = map(string)
}

variable "bootstrap" {
  type = map(string)
}

variable "controlplane_1" {
  type = map(string)
}

variable "controlplane_2" {
  type = map(string)
}

variable "controlplane_3" {
  type = map(string)
}

variable "bootstrap_ignition" {
  description = "Ignition configuration for the bootstrap node"
  type        = string
}

variable "master_ignition" {
  description = "Ignition configuration for the master nodes"
  type        = string
}
