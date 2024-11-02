# Definición del recurso para el archivo Ignition del bootstrap
resource "libvirt_ignition" "bootstrap_ignition" {
  name    = "okd_bootstrap.ign"
  pool    = "default"
  content = file("/home/victory/openshift_okd_cluster/terraform/ignition_configs/bootstrap.ign")

  # Add timeouts to prevent immediate connection attempts
  timeouts {
    create = "5m"
  }
}

# Definición del recurso para el archivo Ignition del master
resource "libvirt_ignition" "master_ignition" {
  name    = "okd_master.ign"
  pool    = "default"
  content = file("/home/victory/openshift_okd_cluster/terraform/ignition_configs/master.ign")

  # Add timeouts to prevent immediate connection attempts
  timeouts {
    create = "5m"
  }
}
