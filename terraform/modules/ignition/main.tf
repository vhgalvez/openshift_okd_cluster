resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = "default"
  content = "/home/victory/openshift-okd/terraform/ignition_configs/bootstrap.ign"
}

resource "libvirt_ignition" "master_ignition" {
  name    = "okd_master.ign"
  pool    = "default"
  content = "/home/victory/openshift-okd/terraform/ignition_configs/master.ign"
}