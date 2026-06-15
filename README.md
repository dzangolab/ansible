# Dzangolab Ansible Collection

[![Publish to Ansible Galaxy](https://github.com/dzangolab/ansible/actions/workflows/publish.yml/badge.svg)](https://github.com/dzangolab/ansible/actions/workflows/publish.yml)

A collection of Ansible roles maintained by [dzangolab](https://dzangolab.com).

## Requirements

- Ansible >= 2.17.6

## Installation

```bash
ansible-galaxy collection install dzangolab.ansible
```

## Upgrade

```bash
ansible-galaxy collection install dzangolab.ansible --upgrade
```

## Roles

### `awscli2`

Installs [AWS CLI v2](https://docs.aws.amazon.com/cli/).

### `docker_portainer`

Installs [Portainer](https://docs.portainer.io/) server and agent as Docker containers in a Docker swarm.

### `docker_traefik`

Installs [Traefik](https://doc.traefik.io/traefik/) as a reverse proxy in a Docker swarm, with optional ACME/Let's Encrypt support and a password-protected dashboard.

## Contributing

### Setup

Copy `.env.example` to `.env` and fill in your Ansible Galaxy API key:

```bash
cp .env.example .env
```

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
source .env && make publish
```

### Release (build + publish)

```bash
source .env && make release
```

Releases are also published automatically to Ansible Galaxy when a `v*` tag is pushed to GitHub:

```bash
git tag v0.5.0
git push --tags
```

## License

MIT
