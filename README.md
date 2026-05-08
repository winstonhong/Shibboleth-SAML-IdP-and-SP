# Shibboleth SAML IdP and SP (Docker)

Docker-based demo of a **Shibboleth Identity Provider (IdP)** and **Service Provider (SP)** backed by **OpenLDAP**, derived from the upstream Shibboleth ecosystem.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/) (Compose v1: `docker-compose`; v2: `docker compose`)
- Permission to run `docker` (add your user to the `docker` group, or prefix commands with `sudo` if your environment requires it)

## What’s included


| Component      | Directory                    | Image tag                       | Purpose                          |
| -------------- | ---------------------------- | ------------------------------- | -------------------------------- |
| OpenLDAP       | `LDAP-Dockerized-CentOS/`    | `example/openldap:latest`       | Directory for IdP authentication |
| Shibboleth IdP | `shibboleth-idp-dockerized/` | `example/shibboleth-idp:latest` | SAML IdP (Jetty)                 |
| Shibboleth SP  | `shibboleth-sp-testapp/`     | `example/shibboleth-sp:latest`  | Sample SP and protected app      |


**Port mapping (typical `run.sh` / Compose):**

- LDAP: **389**
- IdP: **443→4443** (browser TLS), **8443**, **80→8080**
- SP: **2080→80**, **2443→443**

Start **OpenLDAP before the IdP** so LDAP is reachable at hostname `**openldap`** (Compose DNS replaces legacy `--link`).

## Build and run (individual stacks)

From the repository root, build images in this order:

```bash
git clone https://github.com/winstonhong/Shibboleth-SAML-IdP-and-SP.git
cd Shibboleth-SAML-IdP-and-SP

# 1) OpenLDAP
cd LDAP-Dockerized-CentOS
sudo bash build.sh && sudo bash run.sh
cd ..

# 2) Shibboleth IdP
cd shibboleth-idp-dockerized
sudo bash build.sh && sudo bash run.sh
cd ..

# 3) Shibboleth SP
cd shibboleth-sp-testapp
sudo bash build.sh && sudo bash run.sh
cd ..
```

## Docker Compose

From the **repository root**, Compose uses the **same** build contexts and runtime settings as the three `build.sh` / `run.sh` pairs:


| Manual step                          | Compose                                                                        |
| ------------------------------------ | ------------------------------------------------------------------------------ |
| `LDAP-Dockerized-CentOS/build.sh`    | `build.context: ./LDAP-Dockerized-CentOS` → `example/openldap:latest`          |
| `shibboleth-idp-dockerized/build.sh` | `build.context: ./shibboleth-idp-dockerized` → `example/shibboleth-idp:latest` |
| `shibboleth-sp-testapp/build.sh`     | `build.context: ./shibboleth-sp-testapp` → `example/shibboleth-sp:latest`      |


**Start order** matches the numbered steps: **openldap** → **shibboleth-idp** → **shibboleth-sp** (`depends_on`). Ports, IdP env vars, volume mount for `ext-conf`, and `-it`-equivalent flags (`stdin_open` / `tty` on IdP and SP) align with the scripts.

```bash
# Build all three images and start (equivalent to running each build.sh then each run.sh)
sudo docker compose up --build

# Or use existing local images only (same as having run the three build.sh scripts already)
sudo docker compose up
```

If you already started containers with the shell scripts, stop them first so names do not clash (`docker stop openldap shibboleth-idp shibboleth-sp` or `docker compose down` after switching).

## Demo

1. Open **[https://sp.example.org:2443](https://sp.example.org:2443)** (trust the demo certificate in your browser if prompted).
2. Click **Login**.
3. You are redirected to the Shibboleth IdP login page.
4. Sign in with a directory user, for example:
  - **winstonhong** / **winston-passwd**
  - **ethansmith** / **ethan-passwd**
5. After authentication you are sent back to the SP-protected content.

*(Hosts file: ensure `sp.example.org` resolves to your Docker host, e.g. `127.0.0.1 sp.example.org`, if required by your setup.)*

## Compatibility

Validated on **Ubuntu 26.04** with current Docker. The LDAP and IdP images are based on **CentOS 7** (EOL); Dockerfiles repoint `yum` to the CentOS Vault and EPEL archives where needed so builds keep working.

## References

- [Shibboleth Consortium](https://www.shibboleth.net/)
- [Shibboleth Identity Provider — Unicon Docker base](https://github.com/Unicon/shibboleth-idp-dockerized)
- [Shibboleth Service Provider — Unicon Docker base](https://github.com/Unicon/shibboleth-sp-dockerized)

## Credits

Demo and packaging by [winstonhong](https://github.com/winstonhong) @ [inbaytech](https://github.com/inbaytech).