resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = "default"
  content = "${path.module}/../ignition_configs/bootstrap.ign"
}

resource "libvirt_ignition" "master_ignition" {
  name    = "okd_master.ign"
  pool    = "default"
  content = "${path.module}/../ignition_configs/master.ign"
}