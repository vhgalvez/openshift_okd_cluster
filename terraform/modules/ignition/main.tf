# Define volume for the bootstrap Ignition file
resource "libvirt_volume" "bootstrap_ignition" {
  name   = "okd_bootstrap.ign"
  pool   = "default"
  source = "${path.module}/../../ignition_configs/bootstrap.ign"
  format = "raw"
}

# Define volume for the master Ignition file
resource "libvirt_volume" "master_ignition" {
  name   = "okd_master.ign"
  pool   = "default"
  source = "${path.module}/../../ignition_configs/master.ign"
  format = "raw"
}