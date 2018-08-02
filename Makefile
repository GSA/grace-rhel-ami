# SHELL := /bin/bash
TENANT_ACCOUNTS := $(shell aws organizations list-accounts-for-parent --parent-id ou-bgtv-tu73r6dm --query "Accounts[].Id" --output text --page-size 1 | sed -n -e 'H;$${x;s/\n/,/g;s/^,//;p;}')

default: rhel7

roles:
	ansible-galaxy install -p ansible/roles -r ansible/requirements.yml --force

validate_ansible: roles
	cd ansible && ansible-playbook --syntax-check rhel7_base.yml

validate_packer:
	packer validate -syntax-only packer/template.json
	packer validate -var-file=packer/rhel7.json packer/template.json

rhel7: roles
	packer build -var-file=packer/rhel7.json packer/template.json
