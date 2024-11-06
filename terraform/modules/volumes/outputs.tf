// terraform\modules\volumes\outputs.tf

output "bootstrap_volume_id" {
  value = libvirt_volume.bootstrap.id
}

output "controlplane_1_volume_id" {
  value = libvirt_volume.controlplane_1.id
}

output "controlplane_2_volume_id" {
  value = libvirt_volume.controlplane_2.id
}

output "controlplane_3_volume_id" {
  value = libvirt_volume.controlplane_3.id
}
