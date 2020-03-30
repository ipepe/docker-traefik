# docker-traefik-with-self-signed-ssl
Reconfigured traefik for HTTP redirect to HTTPS. With default self signed certificate and letsencrypt support.

# Production docker-compose.yml

```yaml
version: '2'
services:
  reverse-proxy:
    image: ipepe/traefik:1.7
    restart: always
    network_mode: bridge
    command: --acme.email="letsencrypt@example.org"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080" # The Web UI (enabled by --api)
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock # So that Traefik can listen to the Docker events

```

# Exmaple other container
```yaml
version: '2'
services:
  swagger-editor:
    image: swaggerapi/swagger-editor
    restart: always
    network_mode: bridge
    expose:
      - '8080'
    labels:
      - 'traefik.enable=true'
      - 'traefik.port=8080'
      - 'traefik.frontend.rule=Host:swagger.example.org'
```
