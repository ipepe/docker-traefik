FROM frapsoft/openssl as openssl
RUN mkdir -p /opt/traefik/certs && \
    chmod 755 /opt/traefik && \
    chmod 750 /opt/traefik/certs && \
    openssl req -x509 -newkey rsa:4096 -keyout /opt/traefik/certs/default.key -out /opt/traefik/certs/default.crt -days 2048 -subj '/CN=localhost' -nodes && \
    chmod 644 /opt/traefik/certs/default.crt && \
    chmod 600 /opt/traefik/certs/default.key

FROM traefik:v1.7.30-alpine
MAINTAINER docker@ipepe.pl
COPY --from=openssl /opt/traefik/certs/ /opt/traefik/certs/
ADD traefik.toml /traefik.toml
