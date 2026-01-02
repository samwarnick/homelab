all:
  children:
    vms:
      hosts:
%{ for name, config in vms ~}
        ${name}:
          ansible_host: ${config.ip}
%{ endfor ~}
      vars:
        ansible_user: ubuntu
    lxcs:
      hosts:
%{ for name, config in lxcs ~}
        ${name}:
          ansible_host: ${config.ip}
%{ endfor ~}
      vars:
        ansible_user: root
  vars:
    ansible_ssh_private_key_file: ~/.ssh/id_rsa
