# Configuración y despliegue de máquinas virtuales con Fedora CoreOS y QEMU Guest Agent

Este documento detalla el proceso paso a paso para configurar y desplegar máquinas virtuales (VMs) con Fedora CoreOS utilizando Terraform, QEMU, y el agente de QEMU Guest Agent. El objetivo es crear un entorno escalable donde cada máquina tenga una configuración personalizada a través de Ignition.

## Requisitos previos

- **Linux Kernel**: Versión 4.14 o superior.
- **Libvirt**: Versión 3.0 o superior.
- **QEMU**: Versión 2.6 o superior.
- **Terraform**: Instalado y configurado para gestionar el entorno.
- **Podman/Docker**: Para gestionar contenedores y exportar imágenes de contenedor.

## Descripción del proyecto

En este ejemplo se utilizará Fedora CoreOS como sistema operativo para las máquinas virtuales. Se aprovechará Terraform para la automatización de la creación y configuración de las VMs, así como Ignition para aplicar configuraciones iniciales como montar el directorio de imágenes Docker y activar el agente de QEMU.

El uso del agente de QEMU Guest Agent permite que libvirt pueda recoger información como las direcciones IP de las VMs, permitiendo un manejo más efectivo del entorno.

## Paso a paso para instalar y configurar el agente de QEMU

### 1. Descargar la imagen del agente de QEMU Guest Agent

Primero, descarga la imagen del contenedor que contiene el agente de QEMU Guest Agent. Utiliza Podman o Docker:

```sh
$ docker pull docker.io/rancher/os-qemuguestagent:v2.8.1-2
```

Este comando descarga la imagen del agente de QEMU Guest Agent desde el repositorio de Docker.

### 2. Guardar la imagen en un archivo TAR

Una vez descargada la imagen, guárdala en un archivo TAR para poder transferirla y utilizarla en las máquinas virtuales.

```sh
$ sudo podman save docker.io/rancher/os-qemuguestagent:v2.8.1-2 -o /srv/images/qemu-guest-agent.tar
```

Si el directorio `/srv/images` no tiene los permisos correctos, debes asegurarte de que el usuario pueda escribir en él:

```sh
$ sudo chown victory:victory /srv/images
$ sudo chmod 777 /srv/images
```

Esto permitirá que Podman guarde la imagen en ese directorio sin problemas de permisos.

### 3. Configurar SELinux

Si SELinux está habilitado y en modo "enforcing", podría causar problemas de acceso a los archivos. Puedes cambiar el modo a "permissive" para evitar problemas de permisos temporales:

```sh
$ sudo setenforce 0
```

Esto cambia SELinux a modo permisivo, pero asegúrate de volver a "enforcing" una vez hayas terminado la configuración para mantener la seguridad del sistema.

### 4. Mover la imagen al directorio de imágenes

Una vez la imagen ha sido exportada, muevela al directorio `/srv/images` para que esté disponible para las máquinas virtuales.

```sh
$ sudo mv /home/victory/qemu-guest-agent.tar /srv/images/qemu-guest-agent.tar
```

### 5. Configurar los archivos de Ignition

Los archivos `docker-images.mount` y `qemu-agent.service` son necesarios para que la configuración de Ignition pueda montar la imagen y activar el servicio del agente. Estos archivos deben ser parte de la configuración de Ignition.

En Terraform, puedes definir estos archivos usando `ignition_systemd_unit` de la siguiente manera:

```hcl
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
```

### 6. Configuración de máquinas virtuales en Terraform

Finalmente, define las máquinas virtuales usando Terraform. Cada máquina virtual utilizará Ignition para configurar su entorno inicial.

```hcl
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
```

### 7. Desplegar el entorno con Terraform

Ejecuta `terraform init` y `terraform apply` para inicializar y desplegar el entorno. Esto creará las máquinas virtuales y aplicará las configuraciones de Ignition necesarias.

```sh
$ terraform init
$ terraform apply
```

Este proceso desplegará las máquinas y utilizará el agente de QEMU para recolectar información sobre la VM, como la dirección IP.

### Conclusión

Este documento cubre los pasos necesarios para desplegar un entorno de máquinas virtuales con Fedora CoreOS y configurar el agente de QEMU Guest Agent utilizando Terraform e Ignition. La configuración de Ignition y la correcta integración del agente de QEMU permiten una gestión eficiente del entorno y el control de las VMs a través de libvirt.

Asegúrate de seguir todos los pasos, desde la descarga de la imagen hasta la configuración de Ignition, para garantizar que las máquinas virtuales estén completamente operativas y correctamente configuradas.

