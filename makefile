#!make

VERSION  := $(shell grep '^version:' galaxy.yml | awk '{print $$2}')
TARBALL  := dzangolab-ansible-$(VERSION).tar.gz

build:
	@printf "\033[0;32m>>> Build collection v$(VERSION)\033[0m\n"
	ansible-galaxy collection build

install:
	@printf "\033[0;32m>>> Install collection from galaxy server\033[0m\n"
	ansible-galaxy collection install dzangolab.ansible

install.local: build
	@printf "\033[0;32m>>> Install collection locally\033[0m\n"
	ansible-galaxy collection install --force $(TARBALL)

publish: build
	@printf "\033[0;32m>>> Publish collection v$(VERSION)\033[0m\n"
	ansible-galaxy collection publish $(TARBALL) --api-key "$(ANSIBLE_GALAXY_API_KEY)"

release: publish

upgrade:
	@printf "\033[0;32m>>> Upgrade collection from galaxy server\033[0m\n"
	ansible-galaxy collection install dzangolab.ansible --upgrade
