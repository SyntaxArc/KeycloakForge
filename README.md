Here’s the updated README for your repository "KeycloakForge" hosted at `https://github.com/SyntaxArc/KeycloakForge`. It reflects your specific setup without a license section, as requested.

---

# KeycloakForge

This project, KeycloakForge, sets up a Keycloak identity and access management server with a PostgreSQL database and an Nginx reverse proxy for secure HTTPS access. The configuration is managed using Docker Compose.

## Features
- **Keycloak**: Version 26.1.3, running with preview features enabled.
- **PostgreSQL**: Version 17-alpine, used as the persistent database for Keycloak.
- **Nginx**: Acts as a reverse proxy, terminating TLS and forwarding traffic to Keycloak.
- **Security**: HTTPS enforced, CORS configured, and security headers applied.
- **Docker Compose**: Manages all services in a single configuration.

## Prerequisites
- [Docker](https://docs.docker.com/get-docker/)  installed.
- Basic knowledge of Docker, Nginx, and Keycloak administration.

## Directory Structure
```
.
├── docker compose.yml    # Docker Compose configuration
├── nginx.conf           # Nginx configuration file
├── certs/              # Directory for SSL certificates
│   ├── keycloak.crt    # SSL certificate
│   └── keycloak.key    # SSL private key
└── README.md           # This file
```

## Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/SyntaxArc/KeycloakForge.git
cd KeycloakForge
```

### 2. Configure SSL Certificates
- Place your SSL certificate and key in the `certs/` directory:
  - `keycloak.crt`: Your SSL certificate.
  - `keycloak.key`: Your SSL private key.
- For testing, generate self-signed certificates:
  ```bash
  mkdir certs
  openssl req -x509 -newkey rsa:4096 -keyout certs/keycloak.key -out certs/keycloak.crt -days 365 -nodes
  ```
- For production, use a valid certificate (e.g., from Let’s Encrypt).

### 3. Update Configuration
- **Domain**: Replace `localhost` in `docker compose.yml` (`KC_HOSTNAME`) and `nginx.conf` (`server_name`) with your domain (e.g., `keycloak.example.com`).
- **Passwords**: Update `KC_DB_PASSWORD`, `KEYCLOAK_ADMIN_PASSWORD`, and `POSTGRES_PASSWORD` in `docker compose.yml` with secure values.

### 4. Start the Services
```bash
docker compose up -d
```
- This starts Keycloak, PostgreSQL, and Nginx in detached mode.

### 5. Verify the Setup
- Access the Keycloak admin console: `https://localhost/admin` (or your domain).
- Log in with the admin credentials (`admin` / `admin_secure_password` by default).
- Check container logs if needed:
  ```bash
  docker logs keycloak-container
  docker logs nginx-container
  docker logs postgres-container
  ```

## Configuration Details

### Docker Compose (`docker compose.yml`)
- **Keycloak**:
  - Image: `quay.io/keycloak/keycloak:26.1.3`
  - Ports: Exposed internally on `8080` (proxied by Nginx).
  - Environment: Configures database, admin credentials, hostname, and proxy settings.
- **PostgreSQL**:
  - Image: `postgres:17-alpine`
  - Volume: Persists data in `keycloak-postgres-data`.
- **Nginx**:
  - Image: `nginx:latest`
  - Ports: `80` (HTTP, redirects to HTTPS), `443` (HTTPS).
  - Volumes: Mounts `nginx.conf` and `certs/`.

### Nginx Configuration (`nginx.conf`)
- Redirects HTTP to HTTPS.
- Terminates TLS with provided certificates.
- Proxies requests to Keycloak with proper headers.
- Includes CORS headers to allow cross-origin requests from `https://localhost` (update for your domain).
- Security headers: HSTS, XSS protection, etc.

### CORS Handling
- Nginx adds `Access-Control-Allow-Origin` for static assets and API calls.
- Keycloak can also be configured for CORS via `KC_CORS` environment variables if needed.

## Usage
- **Admin Console**: Manage users, realms, and clients at `https://localhost/admin`.
- **Client Applications**: Configure your apps to use Keycloak for authentication (e.g., OpenID Connect).
- **Metrics & Health**: Enabled in Keycloak (`KC_METRICS_ENABLED`, `KC_HEALTH_ENABLED`).

## Troubleshooting
- **CORS Errors**: Check `Access-Control-Allow-Origin` in response headers. Adjust `nginx.conf` or Keycloak’s `KC_CORS_ALLOWED_ORIGINS`.
- **499 Errors**: Increase proxy timeouts in `nginx.conf` or check Keycloak logs for delays.
- **Logs**:
  ```bash
  docker logs nginx-container --tail 100
  docker logs keycloak-container --tail 100
  ```
- **Restart Services**:
  ```bash
  docker compose restart <service-name>
  ```

## Stopping the Services
```bash
docker compose down
```
- To remove volumes (data):
  ```bash
  docker compose down -v
  ```

## Notes
- Replace `localhost` with your production domain and update DNS accordingly.
- Secure passwords and certificates before deploying to production.
- Adjust `JAVA_OPTS` in Keycloak or Nginx worker settings based on your server’s resources.

