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

variable "hostname_prefix" {
variable "hosts" {
  type        = number
  description = "Number of hosts"
}

  type = string
}

variable "controlplane_count" {
  type = number
}
