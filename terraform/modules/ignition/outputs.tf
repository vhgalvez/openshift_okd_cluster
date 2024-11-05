# modules/ignition/outputs.tf

output "bootstrap_ignition_id" {
  value = libvirt_volume.bootstrap_ignition.id
}

output "master_ignition_id" {
  value = libvirt_volume.master_ignition.id
}
