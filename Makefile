# Essential tools for linux
install:
	sudo apt update && \
	sudo apt install bridge-utils qemu-kvm virtinst libvirt-dev libvirt-daemon virt-manager && \
	wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update && sudo apt install vagrant && \
	vagrant plugin install vagrant-libvirt vagrant-disksize vagrant-vbguest && \
	sudo apt install software-properties-common && \
    sudo apt-add-repository --yes --update ppa:ansible/ansible && \
    sudo apt install ansible \
    sudo apt install kubectl

# Provision Virtual Machines
up:
	VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up

# Create kubernetes cluster
cluster: clear-ssh
	cd ansible && ansible-playbook -i hosts -u root --key-file "vagrant" main.yaml --extra-vars "@vars.yaml"

# Reset remembering ssh keys
clear-ssh:
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.51 && \
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.52 && \
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.101 && \
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.102 && \
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.103 && \
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.201 && \
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.202 && \
	ssh-keygen -f ~/.ssh/known_hosts -R 10.1.1.203

# Reset everything
reset: clear-ssh
	VAGRANT_DEFAULT_PROVIDER=libvirt vagrant destroy -f

# Graceful shutdown of Virtual Machines
halt:
	VAGRANT_DEFAULT_PROVIDER=libvirt vagrant halt
