# Ansible Role: 

Installs [traefik](https://traefik.io/) proxy as a Docker container in a Docker swarm.

## Requirements

This role requires Ansible 2.17.6 or higher and have htpasswd installed.

## Role variables

Ansible variables are listed below with their default values.

```
traefik__access_log_format: common
traefik__acme_caserver: https://acme-v02.api.letsencrypt.org/directory
traefik__acme_email: 

traefik__dashboard: true
traefik__dashboard_basicauth_passwords: []

traefik__deploy_dir:
traefik__deploy_group: 
traefik__deploy_user:

traefik__expose_by_default: false

traefik__image: traefik:v2.5.3

traefik__label: traefik
traefik__log_dir: /var/log/traefik
traefik__log_format: common
traefik__log_level: ERROR

traefik__network: traefik

traefik__refresh: 15

traefik__state: started | stopped
```

## Example playbook

```
---
- hosts: webservers
  roles:
    - dzangolab.docker_traefik
      traefik_certificates:
      -
      	{
      		CertFile: "/path/to/certificate.crt",
      		KeyFile: "/path/tto/keyfile.key"
      	}
      traefik__domain: mydomain.com
      traefik__network: mydomain
```

## License

MIT

