# terraform\modules\domain\main.tf

provider "ignition" {
  source  = "community-terraform-providers/ignition"
  version = "2.1.0"
}

# Configuración de los archivos de Ignition para montar el directorio de imágenes Docker y el servicio del agente de QEMU

data "ignition_systemd_unit" "mount_images" {
  name    = "var-mnt-images.mount"
  enabled = true
  content = file("${path.module}/../../docker-images-mount/docker-images.mount")
}

data "ignition_systemd_unit" "qemu_agent" {
  name    = "qemu-agent.service"
  enabled = true
  content = file("${path.module}/../../docker-images-mount/qemu-agent.service")
}

# Definición de la configuración de Ignition reutilizable
module "ignition_config" {
  source                  = "../ignition"
  hosts                   = var.hosts
  hostname_prefix         = var.hostname_prefix
  mount_images_content    = data.ignition_systemd_unit.mount_images.rendered
  qemu_agent_content      = data.ignition_systemd_unit.qemu_agent.rendered
  core_user_password_hash = "$6$hNh1nwO5OWWct4aZ$OoeAkQ4gKNBnGYK0ECi8saBMbUNeQRMICcOPYEu1bFuj9Axt4Rh6EnGba07xtIsGNt2wP9SsPlz543gfJww11/"
}

# Definición de las máquinas virtuales de OKD

resource "libvirt_domain" "okd_bootstrap" {
  name        = var.bootstrap.name
  description = var.bootstrap.description
  vcpu        = var.bootstrap.vcpu
  memory      = var.bootstrap.memory * 1024 # MiB
  running     = true
  qemu_agent  = true

  # Attach the Ignition volume as a disk
  disk {
    volume_id = var.bootstrap_ignition_id
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "efi"

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

# Definición de las máquinas de control plane

resource "libvirt_domain" "okd_controlplane_1" {
  name        = var.controlplane_1.name
  description = var.controlplane_1.description
  vcpu        = var.controlplane_1.vcpu
  memory      = var.controlplane_1.memory * 1024 # MiB
  running     = true
  qemu_agent  = true

  # Attach the Ignition volume as a disk
  disk {
    volume_id = var.master_ignition_id
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "efi"

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
  name        = var.controlplane_2.name
  description = var.controlplane_2.description
  vcpu        = var.controlplane_2.vcpu
  memory      = var.controlplane_2.memory * 1024 # MiB
  running     = true
  qemu_agent  = true

  # Attach the Ignition volume as a disk
  disk {
    volume_id = var.master_ignition_id
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "efi"

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
  qemu_agent      = true

  # Attach the Ignition volume as a disk
  disk {
    volume_id = var.master_ignition_id
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "efi"

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
