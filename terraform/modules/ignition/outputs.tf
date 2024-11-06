# modules/ignition/outputs.tf

output "bootstrap_ignition_content" {
    value = data.local_file.bootstrap_ignition.content
}

output "master_ignition_content" {
    value = data.local_file.master_ignition.content
}
