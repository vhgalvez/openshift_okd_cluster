# terraform\modules\volumes\variables.tf
variable "coreos_image" {
  type        = string
  description = "CoreOS image to use"
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

variable "worker" {
  type = map(string)
}

variable "hostname_format" {
  type    = string
  default = "coreos%02d"
}
