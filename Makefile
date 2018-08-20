default: rhel7 rhel6

roles:
	ansible-galaxy install -p ansible/roles -r ansible/requirements.yml --force

validate_ansible: roles
	cd ansible && ansible-playbook --syntax-check rhel7_base.yml

validate_packer:
	packer validate -syntax-only packer/template.json
	packer validate -var-file=packer/rhel7.json packer/template.json

rhel7: roles
	packer build -var-file=packer/rhel7.json packer/template.json

rhel6: roles
	packer build -var-file=packer/rhel6.json packer/template.json