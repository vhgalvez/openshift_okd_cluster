variable "network_id" {
  type        = string
  description = "value of network_id"
}

variable "bootstrap_volume_id" {
  type        = string
  description = "value of bootstrap_volume_id"
}

variable "bootstrap_ignition_id" {
  type        = string
  description = "value of bootstrap_ignition_id"
}

variable "controlplane_1_volume_id" {
  type        = string
  description = "value of controlplane_1_volume_id"
}

variable "controlplane_2_volume_id" {
  type        = string
  description = "value of controlplane_2_volume_id"
}

variable "controlplane_3_volume_id" {
  type        = string
  description = "value of controlplane_3_volume_id"
}

variable "master_ignition_id" {
  type        = string
  description = "value of master_ignition_id"
}

variable "hostname_prefix" {
  type        = string
  description = "Prefix for hostnames"
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

variable "hosts" {
  type        = number
  description = "Number of hosts"
  default     = 3
}

variable "controlplane_count" {
  type        = number
  description = "Number of control planes"
  default     = 3
}
