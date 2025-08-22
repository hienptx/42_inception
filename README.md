# Inception Project

A complete Docker-based LEMP stack (Linux, Nginx, MariaDB, PHP) with WordPress, built from scratch and orchestrated with Docker Compose.

## Overview

Inception builds a small web platform composed of isolated containers:

- **Nginx** — reverse proxy and TLS termination
- **WordPress + PHP-FPM** — application stack
- **MariaDB** — database server
- **Docker Compose** — service orchestration

Services run on a custom Docker network and persist data using volumes.

## Requirements

- Linux-based OS
- Docker (20.10+) and Docker Compose
- Sudo privileges (for hosts file modification and data directory ownership)

## Quick start

1. Clone and enter the repository:
   ```bash
   git clone <repository-url>
   cd inception
   ```

2. Edit environment variables if needed:
   ```bash
   # Edit srcs/.env for domain, DB and WP credentials
   nano srcs/.env
   ```

3. Prepare data directories and start services:
   ```bash
   make up
   ```

4. Open the site in your browser:
   ```
   https://<DOMAIN_NAME>
   ```

## Makefile targets

| Command | Description |
|---------|-------------|
| `make up` | Create data dirs, build and start containers |
| `make down` | Stop containers |
| `make restart` | Recreate containers |
| `make clean` | Remove containers and images built by the project |
| `make fclean` | Full cleanup (containers, images, volumes, host data) |
| `make re` | `fclean` then `up` |
| `make logs` | Show docker-compose logs |
| `make set-hosts` | Add domain to `/etc/hosts` (requires sudo) |
| `make prepare` | Create data directories and set ownership |

## Project layout

```
inception/
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│       ├── nginx/
│       └── wordpress/
└── docs/
```

## Volumes & persistence

By default the project stores data under `$(HOME)/data` (created by `make prepare`):

- WordPress files: `~/data/wordpress/`
- MariaDB data: `~/data/mariadb/`

You can change this behavior in the Makefile or switch to Docker named volumes.

## Accessing services

MariaDB:
```bash
docker exec -it mariadb bash
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}"
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
```

WordPress container:
```bash
docker exec -it wordpress bash
```

Nginx logs:
```bash
docker logs nginx
```

## Troubleshooting

- Permission issues on `/var/www/html`: ensure host data dir owner matches container user or run WordPress as root for development.
- Database connection: verify `srcs/.env` values and that `mariadb` service is running.
- Rebuild after Dockerfile changes:
  ```bash
  docker compose -f srcs/docker-compose.yml build wordpress
  docker compose -f srcs/docker-compose.yml up -d wordpress
  ```
- Full reset:
  ```bash
  make fclean
  make up
  ```

## Security notes

This project is for learning and development. For production:
- Use secure credentials and secrets management.
- Use valid TLS certificates (Let’s Encrypt).
- Harden MariaDB and Nginx configurations.

## Contributing

Fork, create a branch, commit changes, push, and open a pull request.

## License

Part of the 42 curriculum. No license