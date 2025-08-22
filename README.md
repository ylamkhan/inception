# Inception

A comprehensive Docker infrastructure project that sets up a complete web application stack with WordPress, MySQL, and Nginx using Docker containers, volumes, and networks. Part of the 1337 School system administration curriculum.

## Table of Contents

- [Overview](#overview)
- [Project Requirements](#project-requirements)
- [Architecture](#architecture)
- [Services](#services)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Docker Compose](#docker-compose)
- [Volumes and Networks](#volumes-and-networks)
- [Security](#security)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Bonus Features](#bonus-features)
- [Resources](#resources)
- [Authors](#authors)

## Overview

Inception is a system administration project that demonstrates containerization skills using Docker. The project involves creating a complete web infrastructure with multiple services running in separate containers, connected through Docker networks, and managing persistent data with Docker volumes. All services are orchestrated using Docker Compose and configured with custom Dockerfiles.

## Project Requirements

### Mandatory Requirements

- **Docker Compose**: All services must be orchestrated with docker-compose.yml
- **Custom Dockerfiles**: Each service must have its own Dockerfile (no pre-built images from DockerHub except base OS images)
- **Separate Containers**: Each service runs in its own container
- **Docker Network**: All containers communicate through a Docker network
- **Data Persistence**: Use Docker volumes for persistent data storage
- **Domain Configuration**: Setup custom domain name pointing to localhost
- **SSL/TLS**: All connections must be encrypted (HTTPS/TLS 1.2 or 1.3)
- **Environment Variables**: Use .env file for configuration
- **No Latest Tags**: Specify exact versions for all base images
- **Container Restart Policy**: Containers must restart automatically on crash

### Core Services

1. **Nginx**: Web server with SSL/TLS termination
2. **WordPress**: PHP-FPM based WordPress installation
3. **MariaDB**: Database server for WordPress

## Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Docker Host                              │
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │    Nginx    │    │  WordPress  │    │   MariaDB   │     │
│  │  Container  │◄──►│  Container  │◄──►│  Container  │     │
│  │   (Port     │    │   (PHP-FPM) │    │ (Database)  │     │
│  │   443/80)   │    │             │    │             │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
│         │                   │                   │          │
│  ┌─────────────────────────────────────────────────────────┐  │
│  │            Docker Network (inception)              │  │
│  └─────────────────────────────────────────────────────────┘  │
│         │                   │                   │          │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │   SSL Cert  │    │ WordPress   │    │   Database  │     │
│  │   Volume    │    │   Volume    │    │   Volume    │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### Network Flow

1. **External Request** → Nginx (Port 443/80)
2. **Nginx** → WordPress PHP-FPM (Port 9000)
3. **WordPress** → MariaDB (Port 3306)
4. **All communication** via Docker network `inception`

## Services

### Nginx Container

**Purpose**: Web server, reverse proxy, SSL/TLS termination

**Features**:
- Custom Nginx configuration
- SSL/TLS 1.2+ support
- PHP-FPM proxy to WordPress container
- Security headers and optimizations
- Static file serving

**Base Image**: `debian:bullseye` or `alpine:3.16`

### WordPress Container

**Purpose**: PHP application server running WordPress

**Features**:
- PHP-FPM configuration
- WordPress installation and configuration
- Database connection setup
- File permissions management
- WordPress CLI for administration

**Base Image**: `debian:bullseye` or `alpine:3.16`

### MariaDB Container

**Purpose**: MySQL-compatible database server

**Features**:
- MariaDB server configuration
- Database and user creation
- Data persistence with volumes
- Security configurations
- Performance optimizations

**Base Image**: `debian:bullseye` or `alpine:3.16`

## Installation

### Prerequisites

- **Docker**: Version 20.10+
- **Docker Compose**: Version 2.0+
- **Make**: Build automation tool
- **OpenSSL**: For SSL certificate generation

### Quick Setup

1. **Clone the repository**:
```bash
git clone https://github.com/your-username/inception.git
cd inception
```

2. **Configure environment**:
```bash
cp srcs/.env.example srcs/.env
# Edit .env with your configuration
```

3. **Add domain to hosts file**:
```bash
echo "127.0.0.1 your-login.1337.fr" | sudo tee -a /etc/hosts
```

4. **Build and start services**:
```bash
make
```

5. **Access the website**:
- WordPress: https://yamkhan.1337.fr
- Admin: https://ylamkhan.1337.fr/wp-admin

### Manual Setup

1. **Create directories**:
```bash
sudo mkdir -p /home/your-login/data/wordpress
sudo mkdir -p /home/your-login/data/mariadb
```

2. **Generate SSL certificates**:
```bash
make ssl-cert
```

3. **Build containers**:
```bash
docker-compose -f srcs/docker-compose.yml build
```

4. **Start services**:
```bash
docker-compose -f srcs/docker-compose.yml up -d
```

## Usage

### Makefile Commands

```bash
# Build and start all services
make

# Start services
make up

# Stop services
make down

# Rebuild all containers
make re

# Clean everything (containers, volumes, networks)
make clean

# View logs
make logs

# Show container status
make ps

# Generate SSL certificates
make ssl-cert
```

### Docker Compose Commands

```bash
# Start services
docker-compose -f srcs/docker-compose.yml up -d

# Stop services
docker-compose -f srcs/docker-compose.yml down

# View logs
docker-compose -f srcs/docker-compose.yml logs -f

# Execute commands in containers
docker-compose -f srcs/docker-compose.yml exec nginx sh
docker-compose -f srcs/docker-compose.yml exec wordpress bash
docker-compose -f srcs/docker-compose.yml exec mariadb mysql -u root -p
```

## Configuration

### Environment Variables (.env)

```bash
# Domain configuration
DOMAIN_NAME=your-login.1337.fr

# MySQL configuration
MYSQL_ROOT_PASSWORD=secure_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=secure_wp_password

# WordPress configuration
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=secure_admin_password
WP_ADMIN_EMAIL=admin@your-login.1337.fr
WP_USER=regular_user
WP_USER_PASSWORD=user_password
WP_USER_EMAIL=user@your-login.1337.fr

# WordPress database configuration
WP_DB_NAME=wordpress
WP_DB_USER=wp_user
WP_DB_PASSWORD=secure_wp_password
WP_DB_HOST=mariadb:3306

# WordPress keys and salts
WP_AUTH_KEY=your_auth_key_here
WP_SECURE_AUTH_KEY=your_secure_auth_key_here
WP_LOGGED_IN_KEY=your_logged_in_key_here
WP_NONCE_KEY=your_nonce_key_here
```

### Nginx Configuration

```nginx
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    
    server_name ${DOMAIN_NAME};
    
    ssl_certificate /etc/nginx/ssl/inception.crt;
    ssl_certificate_key /etc/nginx/ssl/inception.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    
    root /var/www/html;
    index index.php index.html index.htm;
    
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

## Docker Compose

### docker-compose.yml Structure

```yaml
version: '3.8'

services:
  nginx:
    build: ./requirements/nginx
    container_name: nginx
    depends_on:
      - wordpress
    ports:
      - "443:443"
    volumes:
      - wp-volume:/var/www/html
    restart: on-failure
    networks:
      - inception

  wordpress:
    build: ./requirements/wordpress
    container_name: wordpress
    depends_on:
      - mariadb
    volumes:
      - wp-volume:/var/www/html
    restart: on-failure
    networks:
      - inception
    env_file: .env

  mariadb:
    build: ./requirements/mariadb
    container_name: mariadb
    volumes:
      - db-volume:/var/lib/mysql
    restart: on-failure
    networks:
      - inception
    env_file: .env

volumes:
  wp-volume:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/${USER}/data/wordpress

  db-volume:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/${USER}/data/mariadb

networks:
  inception:
    driver: bridge
```

## Volumes and Networks

### Docker Volumes

**WordPress Volume**:
- **Path**: `/home/your-login/data/wordpress`
- **Purpose**: Store WordPress files, themes, plugins, uploads
- **Mount**: Shared between Nginx and WordPress containers

**Database Volume**:
- **Path**: `/home/your-login/data/mariadb`
- **Purpose**: Persist MySQL database files
- **Mount**: Mounted in MariaDB container

### Docker Network

**Inception Network**:
- **Type**: Bridge network
- **Purpose**: Allow communication between containers
- **Isolation**: Containers isolated from other Docker networks
- **DNS**: Automatic service discovery by container name

## Security

### SSL/TLS Configuration

- **Protocol**: TLS 1.2 and 1.3 only
- **Certificate**: Self-signed for development
- **Cipher Suites**: Strong encryption only
- **HSTS**: HTTP Strict Transport Security enabled

### Container Security

- **Non-root Users**: Services run as non-root users where possible
- **Minimal Base Images**: Use Alpine or Debian slim images
- **No Unnecessary Packages**: Install only required packages
- **Environment Variables**: Sensitive data in .env file
- **Network Isolation**: Containers communicate only through defined network

### WordPress Security

- **Strong Passwords**: Enforced for all accounts
- **Security Keys**: WordPress salts and keys configured
- **File Permissions**: Proper file and directory permissions
- **Database Security**: Separate database user with minimal privileges

## Monitoring

### Health Checks

```bash
# Check container status
docker-compose -f srcs/docker-compose.yml ps

# Check container logs
docker-compose -f srcs/docker-compose.yml logs service_name

# Monitor resource usage
docker stats
```

### Service Verification

```bash
# Test Nginx
curl -k https://your-login.1337.fr

# Test WordPress
curl -k https://your-login.1337.fr/wp-admin/

# Test database connection
docker-compose -f srcs/docker-compose.yml exec mariadb mysql -u wp_user -p wordpress
```

## Troubleshooting

### Common Issues

**Container Won't Start**:
```bash
# Check logs
docker-compose logs container_name

# Check configuration
docker-compose config

# Rebuild container
docker-compose build --no-cache container_name
```

**Permission Issues**:
```bash
# Fix volume permissions
sudo chown -R $USER:$USER /home/$USER/data/
sudo chmod -R 755 /home/$USER/data/
```

**SSL Certificate Issues**:
```bash
# Regenerate certificates
make ssl-cert

# Check certificate validity
openssl x509 -in srcs/requirements/nginx/ssl/inception.crt -text -noout
```

**Database Connection Issues**:
```bash
# Check database logs
docker-compose logs mariadb

# Test database connection
docker-compose exec mariadb mysql -u root -p

# Reset database
docker-compose down -v
make clean
make
```

## Project Structure

```
inception/
├── Makefile
├── README.md
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── nginx.conf
        │   └── tools/
        │       └── setup.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── www.conf
        │   └── tools/
        │       └── setup.sh
        └── mariadb/
            ├── Dockerfile
            ├── conf/
            │   └── 50-server.cnf
            └── tools/
                └── setup.sh
```

### Key Files

- **Makefile**: Automation and management commands
- **docker-compose.yml**: Service orchestration configuration
- **Dockerfiles**: Custom container build instructions
- **Configuration Files**: Service-specific configuration files
- **Setup Scripts**: Initialization and configuration scripts

## Bonus Features

### Additional Services

**Redis**: Caching service for WordPress
```yaml
redis:
  build: ./requirements/bonus/redis
  container_name: redis
  restart: on-failure
  networks:
    - inception
```

**FTP Server**: File transfer service
```yaml
ftp:
  build: ./requirements/bonus/ftp
  container_name: ftp
  ports:
    - "21:21"
  volumes:
    - wp-volume:/var/www/html
  restart: on-failure
  networks:
    - inception
```

**Adminer**: Database administration interface
```yaml
adminer:
  build: ./requirements/bonus/adminer
  container_name: adminer
  depends_on:
    - mariadb
  ports:
    - "8080:8080"
  restart: on-failure
  networks:
    - inception
```

**Static Website**: Additional service showcase
```yaml
website:
  build: ./requirements/bonus/website
  container_name: website
  ports:
    - "8081:80"
  restart: on-failure
  networks:
    - inception
```

### Bonus Points

- **+1 point** per additional service (max 5 services)
- **Extra credit** for service creativity and complexity
- **Documentation bonus** for comprehensive setup guides

## Resources

### Documentation
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [Nginx Configuration Guide](https://nginx.org/en/docs/)
- [WordPress Installation Guide](https://wordpress.org/support/article/how-to-install-wordpress/)
- [MariaDB Documentation](https://mariadb.org/documentation/)

### Tutorials
- [Docker Container Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [SSL/TLS Configuration](https://ssl-config.mozilla.org/)
- [WordPress Security Guide](https://wordpress.org/support/article/hardening-wordpress/)

## Authors

- **Youssef Lmkhantar** - *System Administrator* - [YourGithub](https://github.com/ylamkhan/)

---

**Project Grade**: ⭐⭐⭐ (100/100 + Bonus)

*This project demonstrates proficiency in containerization, orchestration, and infrastructure management using Docker technologies.*

## License

This project is part of the 1337 School curriculum and is intended for educational purposes only.

---

*Built with Docker 🐳 at 1337 School*

![Alt text](https://github.com/ylamkhan/inception/raw/main/images/Untitled%20Diagram.drawio.png)

