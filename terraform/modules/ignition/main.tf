# Definición del recurso para el archivo Ignition del bootstrap
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/bootstrap.ign")
}

# Definición del recurso para el archivo Ignition del master
resource "libvirt_ignition" "master_ignition" {
  name    = "okd_master.ign"
  pool    = "default"
  content = file("${path.module}/../../ignition_configs/master.ign")
}