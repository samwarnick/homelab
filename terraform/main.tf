module "vms" {
  source   = "./modules/ubuntu-vm"
  for_each = var.vms

  vm_name   = each.key
  vm_ip     = each.value.ip
  cores     = each.value.cores
  memory    = each.value.memory
  disk_size = each.value.disk_size
  gateway   = var.gateway
}

module "lxcs" {
  source   = "./modules/ubuntu-lxc"
  for_each = var.lxcs

  lxc_name  = each.key
  lxc_ip    = each.value.ip
  cores     = each.value.cores
  memory    = each.value.memory
  disk_size = each.value.disk_size
  gateway   = var.gateway
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.yml.tpl", {
    vms  = var.vms
    lxcs = var.lxcs
  })
  filename = "${path.module}/../ansible/inventory.yml"
}

output "vm_ips" {
  value = { for k, v in module.vms : k => v.ip_address }
}

output "lxc_ips" {
  value = { for k, v in module.lxcs : k => v.ip_address }
}
