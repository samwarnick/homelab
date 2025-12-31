#!/bin/bash
set -e

# Deploy infrastructure
cd terraform
terraform apply -auto-approve

# Configure VMs
cd ../ansible
ansible-playbook -i inventory.yml playbooks/ubuntu-setup.yml
ansible-playbook -i inventory.yml playbooks/coolify-setup.yml

echo "Deployment complete!"
