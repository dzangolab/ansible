#!make

build:
	@printf "\033[0;32m>>> Build collection\033[0m\n"
	ansible-galaxy collection build

install:
	@printf "\033[0;32m>>> Install collection from galaxy server\033[0m\n"
	ansible-galaxy collection install dzangolab.ansible

install.local:
	@printf "\033[0;32m>>> Install collection locally\033[0m\n"
	ansible-galaxy collection install --force dzangolab-ansible-0.1.0.tar.gz 

publish:
	@printf "\033[0;32m>>> Install collection locally\033[0m\n"
	ansible-galaxy collection publish dzangolab-ansible-0.4.1.tar.gz
	
upgrade:
	@printf "\033[0;32m>>> Upgrade collection from galaxy server\033[0m\n"
	ansible-galaxy collection install dzangolab.ansible	--upgrade
