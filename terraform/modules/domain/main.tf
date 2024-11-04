# terraform/modules/domain/main.tf

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

provider "libvirt" {
  uri = "qemu:///system"
}


# Configuración de los archivos de Ignition para montar el directorio de imágenes Docker y el servicio del agente de QEMU

# Definición de la configuración de Ignition reutilizable
module "ignition_config" {
  source                  = "../ignition"
  hosts                   = var.hosts
  hostname_prefix         = var.hostname_prefix
  core_user_password_hash = var.core_user_password_hash
  mount_images_content    = var.mount_images_content
  qemu_agent_content      = var.qemu_agent_content
  bootstrap_ignition_id   = var.bootstrap_ignition_id
  master_ignition_id      = var.master_ignition_id
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
    volume_id = module.ignition_config.bootstrap_ignition
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"

  nvram {
    file = "/var/lib/libvirt/qemu/nvram/${var.bootstrap.name}_VARS.fd"
    template = "/var/lib/libvirt/OVMF_VARS.fd"
  }

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
    volume_id = module.ignition_config.master_ignition
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"

  nvram {
    file = "/var/lib/libvirt/qemu/nvram/${var.controlplane_1.name}_VARS.fd"
    template = "/var/lib/libvirt/OVMF_VARS.fd"
  }

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
    volume_id = module.ignition_config.master_ignition
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"

  nvram {
    file = "/var/lib/libvirt/qemu/nvram/${var.controlplane_2.name}_VARS.fd"
    template = "/var/lib/libvirt/OVMF_VARS.fd"
  }

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
  name        = var.controlplane_3.name
  description = var.controlplane_3.description
  vcpu        = var.controlplane_3.vcpu
  memory      = var.controlplane_3.memory * 1024 # MiB
  running     = true
  qemu_agent  = true

  # Attach the Ignition volume as a disk
  disk {
    volume_id = module.ignition_config.master_ignition
    scsi      = false
  }

  # Use UEFI firmware without secure boot
  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"

  nvram {
    file = "/var/lib/libvirt/qemu/nvram/${var.controlplane_3.name}_VARS.fd"
    template = "/var/lib/libvirt/OVMF_VARS.fd"
  }

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

resource "libvirt_domain" "coreos_machine" {
  count  = var.hosts
  name   = format(var.hostname_format, count.index + 1)
  vcpu   = "1"
  memory = "2048"

  qemu_agent       = true
  coreos_ignition  = element(libvirt_ignition.ignition.*.id, count.index)

  disk {
    volume_id = element(libvirt_volume.coreos-disk.*.id, count.index)
  }

  filesystem {
    source = "/srv/images"
    target = "qemu_docker_images"
    readonly = true
  }

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }
}


