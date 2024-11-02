output "bootstrap_ignition" {
  value = libvirt_volume.bootstrap_ignition.id
}

output "master_ignition" {
  value = libvirt_volume.master_ignition.id
}
