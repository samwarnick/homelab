variable "vm_name" {
  type = string
}

variable "vm_ip" {
  type = string
}

variable "gateway" {
  type = string
}

variable "target_node" {
  type    = string
  default = "pve"
}

variable "ssh_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "cores" {
  type = number
}

variable "memory" {
  type = number
}

variable "disk_size" {
  type = number
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  clone       = "ubuntu-cloud-template"

  agent              = 1
  os_type            = "cloud-init"
  scsihw             = "virtio-scsi-pci"
  start_at_node_boot = true

  cpu {
    cores   = var.cores
    sockets = 1
    type    = "host"
  }

  memory = var.memory

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = "local-zfs"
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = var.disk_size
          storage = "local-zfs"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  boot       = "order=scsi0"
  ipconfig0  = "ip=${var.vm_ip}/24,gw=${var.gateway}"
  nameserver = var.gateway
  sshkeys    = file(var.ssh_key)

  lifecycle {
    ignore_changes = [
      startup_shutdown,
    ]
  }

  provisioner "local-exec" {
    command = "ssh-keygen -R ${var.vm_ip} 2>/dev/null || true"
  }
}

output "ip_address" {
  value = var.vm_ip
}
