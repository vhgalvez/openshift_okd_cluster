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
  mount_images_content    = file("/home/victory/openshift_okd_cluster/terraform/qemu-agent/docker-images.mount")
  qemu_agent_content      = file("/home/victory/openshift_okd_cluster/terraform/qemu-agent/qemu-agent.service")
  bootstrap_ignition_id   = var.bootstrap_ignition_id
  master_ignition_id      = var.master_ignition_id
}

# Definición de las máquinas virtuales de OKD

resource "libvirt_domain" "okd_bootstrap" {
  name   = var.bootstrap.name
  memory = var.bootstrap.memory * 1024
  vcpu   = var.bootstrap.vcpu
  qemu_agent = true

  disk {
    volume_id = var.bootstrap_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.bootstrap.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.bootstrap.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  coreos_ignition = var.bootstrap_ignition_id
}

resource "libvirt_domain" "okd_controlplane_1" {
  name   = var.controlplane_1.name
  memory = var.controlplane_1.memory * 1024
  vcpu   = var.controlplane_1.vcpu
  qemu_agent = true

  disk {
    volume_id = var.controlplane_1_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.controlplane_1.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_1.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  coreos_ignition = var.master_ignition_id
}

resource "libvirt_domain" "okd_controlplane_2" {
  name   = var.controlplane_2.name
  memory = var.controlplane_2.memory * 1024
  vcpu   = var.controlplane_2.vcpu
  qemu_agent = true

  disk {
    volume_id = var.controlplane_2_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.controlplane_2.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_2.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  coreos_ignition = var.master_ignition_id
}

resource "libvirt_domain" "okd_controlplane_3" {
  name   = var.controlplane_3.name
  memory = var.controlplane_3.memory * 1024
  vcpu   = var.controlplane_3.vcpu
  qemu_agent = true

  disk {
    volume_id = var.controlplane_3_volume_id
  }

  network_interface {
    network_id = var.network_id
    mac        = var.controlplane_3.mac
  }

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file = format("/var/lib/libvirt/qemu/nvram/%s_VARS.fd", var.controlplane_3.name)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }

  coreos_ignition = var.master_ignition_id
}

resource "libvirt_domain" "coreos_machine" {
  count  = var.hosts
  name   = format("%s-%d", var.hostname_prefix, count.index + 1)
  vcpu   = "1"
  memory = "2048"

  qemu_agent       = true
  coreos_ignition  = element([var.bootstrap_ignition_id, var.master_ignition_id], count.index)

  disk {
    volume_id = element([var.bootstrap_volume_id, var.controlplane_1_volume_id, var.controlplane_2_volume_id, var.controlplane_3_volume_id], count.index)
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

  firmware = "/usr/share/edk2/ovmf/OVMF_CODE.fd"
  nvram {
    file = format("/var/lib/libvirt/qemu/nvram/%s-%d_VARS.fd", var.hostname_prefix, count.index + 1)
    template = "/usr/share/edk2/ovmf/OVMF_VARS.fd"
  }
}


