# Dzangolab Ansible Collection

A collection of ansible roles. 

## Requirements

* ansible >= 2.17.6

## Usage

### Install

```bash
ansible-galaxy collection install dzangolab.ansible
```
### Upgrade

```bash
ansible-galaxy collection install dzangolab.ansible --upgrade
```

## Roles

### awscli2

Installs [AWS CLI v2](https://docs.aws.amazon.com/cli/).  

### docker-portainer

Install [portainer](https://docs.portainer.io/) in a Docker swarm.

### docker-traefik

Install [traefik](https://doc.traefik.io/traefik/) in a Docker swarm.

## Contribute

### Build

```bash
make build
```

### Install locally

```bash
make install.local
```

### Publish

```bash
make publish
```