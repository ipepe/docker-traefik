# docker-traefik by ipepe
This is based Traefik v1.7. It's important because 2.0 made breaking changes to syntax of toml file and docker labels.

I reconfigured traefik for:
 * HTTP redirect to HTTPS
 * default self signed certificate
   * letsencrypt support.
 * Dashboard enabled by default on port 8080

You don't need to create `traefik.toml` file. Just create `docker-compose.yml` and You are good to go.

# Warning! Insecure default SSL keys.
This container is configured for simplicity. Because of that, default SSL keys are generated in Dockerfile and they can be extracted and used to decrypt ssl communication. They should be treated as leaked/not secure. 

When using it for development or staging responsibly it should not matter. If used behind cloudflare.com it helps a bit, but still insecure.

If traefik succeeds at generating letsencrypt certificate, this warning does not apply. 

You can insert Your own default certificate keys at `/opt/traefik/certs/`.

# Production docker-compose.yml

```yaml
version: '2'
services:
  reverse-proxy:
    image: ipepe/traefik
    restart: always
    network_mode: bridge
    command: --acme.email="letsencrypt@example.org"
    #command: --acme.email="letsencrypt@example.org" --logLevel="DEBUG" --debug=true
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"
    volumes:
       - ./data:/data
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
      - 'traefik.frontend.rule=Host:swagger.example.org,secondhost.example.org'
```
