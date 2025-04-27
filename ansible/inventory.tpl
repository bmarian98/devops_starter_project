[webservers]
${public_ip} ansible_user=ec2-user

; [webservers:vars]
; ansible_ssh_private_key_file=~/.ssh/id_ed25519.pub