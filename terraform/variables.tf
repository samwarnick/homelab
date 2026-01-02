variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_token_id" {
  description = "Proxmox API token ID"
  type        = string
}

variable "proxmox_token_secret" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "gateway" {
  description = "Network gateway"
  type        = string
}

variable "vms" {
  description = "VM configurations"
  type = map(object({
    ip        = string
    cores     = optional(number, 1)
    memory    = optional(number, 2048)
    disk_size = optional(number, 50)
  }))
}

variable "lxcs" {
  description = "LXC configurations"
  type = map(object({
    ip        = string
    cores     = optional(number, 1)
    memory    = optional(number, 1024)
    disk_size = optional(number, 20)
  }))
  default = {}
}
