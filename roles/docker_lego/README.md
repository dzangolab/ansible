# Ansible Role: docker_lego

Deploys [lego](https://go-acme.github.io/lego/) as a Docker Swarm service that obtains and renews TLS certificates via the ACME DNS-01 challenge. Designed to work alongside the `docker_traefik` role when Traefik runs in `global` mode behind a load balancer, where Traefik's built-in ACME cannot be used safely.

Certificates are written to a shared directory (typically NFS-backed) as PEM files alongside Traefik file-provider YAML stubs, so all Traefik instances pick them up automatically without restart.

## Requirements

- Docker Swarm with at least one manager node
- A Cloudflare API token with **Zone DNS Edit** permission on the zone that receives `_acme-challenge` CNAME targets
- A Docker Swarm secret named by `lego__cloudflare_token_secret` (default: `cloudflare-dns-token`) must exist before deploying — the role declares it as `external: true` and does not create it; the calling playbook is responsible for creating it from whatever secret store (Key Vault, Secrets Manager, etc.) the infrastructure uses
- For arbitrary client domains: the client must add a CNAME delegation (see [Adding a domain](#adding-a-domain))

## How it works

The role:

1. Creates the directory structure on the shared volume
2. Writes the cert-update hook and add-domain scripts to `lego__hooks_dir`
3. Templates and deploys a Docker Swarm stack (`replicas: 1`, constrained to manager nodes)

The container (`dzangolab/lego:{{ lego__version }}`) runs `lego renew` immediately on start and every 24 hours. When a certificate is obtained or renewed, the hook script copies the PEM files to `lego__certs_dir` and writes a Traefik file-provider YAML for that domain, which all Traefik instances pick up automatically.

The Cloudflare API token is read from a Docker Swarm secret mounted at `/run/secrets/<lego__cloudflare_token_secret>`. The `dzangolab/lego` image expands `*_FILE` environment variables via `expand_secrets.sh` at entrypoint, so `CLOUDFLARE_DNS_API_TOKEN_FILE` is resolved before lego starts.

## Role variables

```yaml
# ACME
lego__caserver: "https://acme-v02.api.letsencrypt.org/directory"
lego__cloudflare_token_secret: cloudflare-dns-token  # name of the external Docker Swarm secret
lego__dns_provider: cloudflare
lego__dns_resolvers:
  - 8.8.8.8:53
  - 1.1.1.1:53
lego__email: ""
lego__renew_days: 30                 # renew when fewer than this many days remain
lego__version: "4.22.2-1"

# Image
lego__image: dzangolab/lego         # custom image with Docker secrets _FILE support

# Paths (host paths, all bind-mounted into the container)
lego__deploy_dir: /mnt/data/lego     # root; all paths below default to subdirs of this
lego__path: "{{ lego__deploy_dir }}/data"       # lego account and certificate storage
lego__certs_dir: "{{ lego__deploy_dir }}/certs" # PEM output dir shared with Traefik
lego__hooks_dir: "{{ lego__deploy_dir }}/hooks"

# Deploy
lego__deploy_user: root
lego__deploy_group: root
lego__state: started                 # started | stopped
```

## Example playbook

```yaml
- name: Deploy lego
  hosts: swarm_managers[0]
  become: yes
  roles:
    - role: dzangolab.ansible.docker_lego
```

Typical group vars when used alongside `docker_traefik` with a shared NFS mount:

```yaml
lego__deploy_dir: "{{ traefik__deploy_dir }}/lego"
lego__certs_dir: "{{ traefik__deploy_dir }}/certs"  # shared with Traefik; outside lego__deploy_dir
lego__email: devops@example.com
```

`lego__path` and `lego__hooks_dir` derive from `lego__deploy_dir` automatically.

## Adding a domain

### Client DNS prerequisite

The client must add a CNAME record per subdomain so that lego can complete the DNS-01 challenge using your Cloudflare zone without needing access to the client's DNS provider:

```
_acme-challenge.<subdomain>.client.com  CNAME  _acme-challenge.<subdomain>.dzango.tech
```

lego follows the CNAME automatically and creates the required TXT record in your Cloudflare zone.

### Obtaining the certificate

```bash
docker exec $(docker ps -q -f name=lego_lego) sh /hooks/lego-add-domain.sh client.com
```

The script runs `lego run --domains client.com`, then calls the cert-update hook, which copies the PEM files to `lego__certs_dir` and writes `/certs/client.com.yml` for the Traefik file provider.

All Traefik instances pick up the new certificate within seconds via the file provider watch. No Traefik restart is needed.

### Renewal

Renewal is fully automatic. The lego container runs `lego renew --days {{ lego__renew_days }}` every 24 hours, which renews any stored certificate expiring within the configured window and calls the hook for each renewed cert.

## License

MIT
