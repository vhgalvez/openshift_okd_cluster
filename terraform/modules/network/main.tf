terraform {
  required_providers {
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.1.0"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

resource "libvirt_network" "okd_network" {
  name      = "okd_network"
  mode      = "nat"
  domain    = "okd.lab"
  addresses = ["192.168.150.0/24"]
  autostart = true

  lifecycle {
    ignore_changes = [id]
  }

  dns {
    enabled    = true
    local_only = false
  }

  dnsmasq_options {
    // bootstrap
    options {
      option_name  = "address"
      option_value = "/okd-bootstrap.local.okd.lab/${var.bootstrap.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "okd-bootstrap.local.okd.lab,${var.bootstrap.address}"
    }
    options {
      option_name  = "address"
      option_value = "/api-int.local.okd.lab/${var.bootstrap.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "api-int.local.okd.lab,${var.bootstrap.address}"
    }

    // control plane 1
    options {
      option_name  = "address"
      option_value = "/okd-controlplane-1.local.okd.lab/${var.controlplane_1.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "okd-controlplane-1.local.okd.lab,${var.controlplane_1.address}"
    }
    options {
      option_name  = "address"
      option_value = "/api.local.okd.lab/${var.controlplane_1.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "api.local.okd.lab,${var.controlplane_1.address}"
    }
    options {
      option_name  = "address"
      option_value = "/api-int.local.okd.lab/${var.controlplane_1.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "api-int.local.okd.lab,${var.controlplane_1.address}"
    }
    options {
      option_name  = "address"
      option_value = "/oauth-openshift.apps.local.okd.lab/${var.controlplane_1.address}"
    }
    options {
      option_name  = "address"
      option_value = "/console-openshift-console.apps.local.okd.lab/${var.controlplane_1.address}"
    }

    // control plane 2
    options {
      option_name  = "address"
      option_value = "/okd-controlplane-2.local.okd.lab/${var.controlplane_2.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "okd-controlplane-2.local.okd.lab,${var.controlplane_2.address}"
    }
    options {
      option_name  = "address"
      option_value = "/api.local.okd.lab/${var.controlplane_2.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "api.local.okd.lab,${var.controlplane_2.address}"
    }
    options {
      option_name  = "address"
      option_value = "/api-int.local.okd.lab/${var.controlplane_2.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "api-int.local.okd.lab,${var.controlplane_2.address}"
    }
    options {
      option_name  = "address"
      option_value = "/oauth-openshift.apps.local.okd.lab/${var.controlplane_2.address}"
    }
    options {
      option_name  = "address"
      option_value = "/console-openshift-console.apps.local.okd.lab/${var.controlplane_2.address}"
    }

    // control plane 3
    options {
      option_name  = "address"
      option_value = "/okd-controlplane-3.local.okd.lab/${var.controlplane_3.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "okd-controlplane-3.local.okd.lab,${var.controlplane_3.address}"
    }
    options {
      option_name  = "address"
      option_value = "/api.local.okd.lab/${var.controlplane_3.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "api.local.okd.lab,${var.controlplane_3.address}"
    }
    options {
      option_name  = "address"
      option_value = "/api-int.local.okd.lab/${var.controlplane_3.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "api-int.local.okd.lab,${var.controlplane_3.address}"
    }
    options {
      option_name  = "address"
      option_value = "/oauth-openshift.apps.local.okd.lab/${var.controlplane_3.address}"
    }
    options {
      option_name  = "address"
      option_value = "/console-openshift-console.apps.local.okd.lab/${var.controlplane_3.address}"
    }

    // worker
    options {
      option_name  = "address"
      option_value = "/okd-worker.local.okd.lab/${var.worker.address}"
    }
    options {
      option_name  = "host-record"
      option_value = "okd-worker.local.okd.lab,${var.worker.address}"
    }

    // etcd
    options {
      option_name  = "address"
      option_value = "/etcd-0.local.okd.lab/${var.controlplane_1.address}"
    }
    options {
      option_name  = "address"
      option_value = "/etcd-1.local.okd.lab/${var.controlplane_2.address}"
    }
    options {
      option_name  = "address"
      option_value = "/etcd-2.local.okd.lab/${var.controlplane_3.address}"
    }
    options {
      option_name  = "srv-host"
      option_value = "_etcd-server-ssl._tcp,etcd-0.local.okd.lab,2380"
    }
    options {
      option_name  = "srv-host"
      option_value = "_etcd-server-ssl._tcp,etcd-1.local.okd.lab,2380"
    }
    options {
      option_name  = "srv-host"
      option_value = "_etcd-server-ssl._tcp,etcd-2.local.okd.lab,2380"
    }
  }
}

output "okd_network_id" {
  value = libvirt_network.okd_network.id
}
