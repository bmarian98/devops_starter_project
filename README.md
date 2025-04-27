# devops_starter_project

ansible-vault create group_vars/webservers/vault.yml


1. Using Ansible Vault

```  
# Create an encrypted file
ansible-vault create group_vars/all/vault.yml

# In the file, store:
grafana_admin_password: YourStrongPassword123
```

Then reference this variable in your playbook and use the --ask-vault-pass flag when running:

```
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass
```

2. Using environment variables
Update your playbook to read the password from an environment variable:

```
grafana_security:
  admin_user: admin
  admin_password: "{{ lookup('env', 'GRAFANA_ADMIN_PASSWORD') }}"
```

Then run the playbook with:

```
GRAFANA_ADMIN_PASSWORD=YourStrongPassword123 ansible-playbook -i inventory.ini playbook.yml
```

3. Using HashiCorp Vault (more advanced)
For enterprise-level security:

Set up HashiCorp Vault
Store your password in Vault
Use Ansible's HashiCorp Vault integration:

grafana_security:
  admin_user: admin
  admin_password: "{{ lookup('community.hashi_vault.hashi_vault', 'secret=secret/grafana:admin_password') }}"

4. Using a separate vars file with restrictive permissions

```
# Create password file with restrictive permissions
echo "grafana_admin_password: YourStrongPassword123" > password.yml
chmod 600 password.yml
```

Then include it when running the playbook:

```
ansible-playbook -i inventory.ini playbook.yml --extra-vars "@password.yml"
```

How to run ansible to install the Nginx, Prometheus, Node exporter and Grafana.

```ansible
ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass
```