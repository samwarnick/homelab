variable "lxc_name" {
  type = string
}

variable "lxc_ip" {
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

variable "rootfs_storage" {
  type    = string
  default = "local-zfs"
}

resource "proxmox_lxc" "container" {
  target_node  = var.target_node
  hostname     = var.lxc_name
  ostemplate   = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  unprivileged = true
  start        = true
  onboot       = true

  cores  = var.cores
  memory = var.memory

  rootfs {
    storage = var.rootfs_storage
    size    = "${var.disk_size}G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.lxc_ip}/24"
    gw     = var.gateway
  }

  ssh_public_keys = file(var.ssh_key)

  features {
    nesting = true
  }

  lifecycle {
    ignore_changes = [
      startup,
    ]
  }

  # Remove old keys from known_hosts
  provisioner "local-exec" {
    command = "ssh-keygen -R ${var.lxc_ip} 2>/dev/null || true"
  }
}

output "ip_address" {
  value = var.lxc_ip
}
