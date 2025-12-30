This is my experiment with Infrastructure as Code. Still figuring it all out.

Running `./deploy.sh` will run terraform to create VMs in Proxmox and then use Ansible to set them up. Terraform generates the inventory file for me so I can define IPs in one place. Works for me.

Currently using the v3 RC of [`telmate/proxmox`](https://github.com/Telmate/terraform-provider-proxmox) for Proxmox v9 support.

## Example variables

`terraform/terraform.tfvars`

```terraform
proxmox_api_url      = "https://192.168.0.5:8006/api2/json"
proxmox_token_id     = "terraform@pam!token"
proxmox_token_secret = "secret"
gateway              = "192.168.0.1"
vms = {
  example-vm-1 = {
    ip     = "192.168.0.10"
    cores  = 2
    memory = 4096
  }
  example-vm-2 = {
    ip     = "192.168.0.20"
    cores  = 1
    memory = 1024
  }
}
```

`ansible/group-vars/all.yml`

```yml
new_user: deploy
ssh_port: 22
ubuntu_user: ubuntu
allowed_networks:
  - 192.168.0.0/24 #local
  - 100.64.0.0/10 #tailnet
timezone: America/New_York
```

`ansible/host-vars/coolify-home.yml`

```yml
cloudflare_tunnel_token: "token"
```
