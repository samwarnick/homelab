all:
  hosts:
%{ for name, config in vms ~}
    ${name}:
      ansible_host: ${config.ip}
%{ endfor ~}
  vars:
    ansible_user: ubuntu
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
