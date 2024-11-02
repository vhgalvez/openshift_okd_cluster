# terraform\modules\domain\main.tf

data "ignition_config" "startup" {
  users = [
    data.ignition_user.core.rendered,
  ]

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index),
  ]

  systemd = [
    data.ignition_systemd_unit.mount-images.rendered,
    data.ignition_systemd_unit.qemu-agent.rendered
  ]
  count = var.hosts
}

data "ignition_file" "hostname" {
  path       = "/etc/hostname"
  mode       = 420 # decimal 0644

  content {
    content = format(var.hostname_format, count.index + 1)
  }

  count = var.hosts
}

data "ignition_user" "core" {
  name = "core"

  # Example password: foobar
  password_hash = "$5$XMoeOXG6$8WZoUCLhh8L/KYhsJN2pIRb3asZ2Xos3rJla.FA1TI7"
  # Preferably use the ssh key auth instead
  # ssh_authorized_keys = "${list()}"
}

resource "libvirt_domain" "okd_bootstrap" {
  name            = var.bootstrap.name
  description     = var.bootstrap.description
  vcpu            = var.bootstrap.vcpu
  memory          = var.bootstrap.memory * 1024 # MiB
  running         = true
  coreos_ignition = data.ignition_config.startup[count.index].rendered

  disk {
    volume_id = var.bootstrap_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
  }


  graphics {
    type     = "vnc"
    autoport = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  network_interface {
    network_id     = var.network_id
    hostname       = var.bootstrap.name
    addresses      = [var.bootstrap.address]
    mac            = var.bootstrap.mac
    wait_for_lease = true
  }
}

resource "libvirt_domain" "okd_controlplane_1" {
  name            = var.controlplane_1.name
  description     = var.controlplane_1.description
  vcpu            = var.controlplane_1.vcpu
  memory          = var.controlplane_1.memory * 1024 # MiB
  running         = true
  coreos_ignition = data.ignition_config.startup[count.index].rendered

  disk {
    volume_id = var.controlplane_1_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
  }


  graphics {
    type     = "vnc"
    autoport = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  network_interface {
    network_id     = var.network_id
    hostname       = var.controlplane_1.name
    addresses      = [var.controlplane_1.address]
    mac            = var.controlplane_1.mac
    wait_for_lease = true
  }
}
resource "libvirt_domain" "okd_controlplane_2" {
  name            = var.controlplane_2.name
  description     = var.controlplane_2.description
  vcpu            = var.controlplane_2.vcpu
  memory          = var.controlplane_2.memory * 1024 # MiB
  running         = true
  coreos_ignition = data.ignition_config.startup[count.index].rendered

  disk {
    volume_id = var.controlplane_2_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type     = "vnc"
    autoport = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  network_interface {
    network_id     = var.network_id
    hostname       = var.controlplane_2.name
    addresses      = [var.controlplane_2.address]
    mac            = var.controlplane_2.mac
    wait_for_lease = true
  }
}
resource "libvirt_domain" "okd_controlplane_3" {
  name            = var.controlplane_3.name
  description     = var.controlplane_3.description
  vcpu            = var.controlplane_3.vcpu
  memory          = var.controlplane_3.memory * 1024 # MiB
  running         = true
  coreos_ignition = data.ignition_config.startup[count.index].rendered

  disk {
    volume_id = var.controlplane_3_volume_id
    scsi      = false
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type     = "vnc"
    autoport = true
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }



  network_interface {
    network_id     = var.network_id
    hostname       = var.controlplane_3.name
    addresses      = [var.controlplane_3.address]
    mac            = var.controlplane_3.mac
    wait_for_lease = true
  }
}


data "ignition_systemd_unit" "mount-images" {
  name    = "var-mnt-images.mount"
  enabled = true
  content = file("${path.module}/../../docker-images-mount/docker-images.mount")
}

data "ignition_systemd_unit" "qemu-agent" {
  name    = "qemu-agent.service"
  enabled = true
  content = file("${path.module}/../../docker-images-mount/qemu-agent.service")
}