#!/bin/bash
set -e

# Deploy infrastructure
cd terraform
terraform apply -auto-approve

# Configure VMs
cd ../ansible
ansible-playbook -i inventory.yml playbooks/ubuntu-vm-setup.yml
ansible-playbook -i inventory.yml playbooks/coolify-home-setup.yml

# Configure LXCs
ansible-playbook -i inventory.yml playbooks/ubuntu-lxc-setup.yml
ansible-playbook -i inventory.yml playbooks/monitoring-stack-setup.yml
ansible-playbook -i inventory.yml playbooks/uptime-kuma-setup.yml

echo "Deployment complete!"
