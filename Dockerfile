FROM frapsoft/openssl as openssl
RUN mkdir -p /opt/traefik/certs
RUN chmod 755 /opt/traefik
RUN chmod 750 /opt/traefik/certs
RUN openssl req -x509 -newkey rsa:4096 -keyout /opt/traefik/certs/default.key -out /opt/traefik/certs/default.crt -days 2048 -subj '/CN=localhost' -nodes
RUN chmod 644 /opt/traefik/certs/default.crt
RUN chmod 600 /opt/traefik/certs/default.key

FROM traefik:v1.7.24-alpine
MAINTAINER docker@ipepe.pl
COPY --from=openssl /opt/traefik/certs/ /opt/traefik/certs/
ADD traefik.toml /traefik.toml