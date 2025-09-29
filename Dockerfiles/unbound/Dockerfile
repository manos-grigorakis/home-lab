# Base OS
FROM debian:bookworm-slim

# Update & install dependencies
RUN apt-get update && apt-get install -y \
    unbound \
    unbound-anchor \
    ldnsutils \
    curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install root.hints (Root DNS Servers)
RUN curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.root

# Start script
CMD ["sh","-c", "\
  unbound-anchor -v -a /var/lib/unbound/root.key || true && \
  chown -R unbound:unbound /var/lib/unbound && \
  ln -sf /var/lib/unbound/root.key /etc/unbound/root.key && \
  exec unbound -d -c /etc/unbound/unbound.conf"]
