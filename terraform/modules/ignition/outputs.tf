
output "mount_images_content" {
  value = data.ignition_systemd_unit.mount_images.rendered
}

output "qemu_agent_content" {
  value = data.ignition_systemd_unit.qemu_agent.rendered
}

