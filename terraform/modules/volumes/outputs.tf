// terraform\modules\volumes\outputs.tf
output "bootstrap_volume" {
  value = libvirt_volume.okd_bootstrap
}

output "controlplane_1_volume" {
  value = libvirt_volume.okd_controlplane_1
}

output "controlplane_2_volume" {
  value = libvirt_volume.okd_controlplane_2
}

output "controlplane_3_volume" {
  value = libvirt_volume.okd_controlplane_3
}

output "okd_bootstrap_id" {
  value = libvirt_volume.okd_bootstrap.id
}

output "okd_controlplane_1_id" {
  value = libvirt_volume.okd_controlplane_1.id
}

output "okd_controlplane_2_id" {
  value = libvirt_volume.okd_controlplane_2.id
}

output "okd_controlplane_3_id" {
  value = libvirt_volume.okd_controlplane_3.id
}
