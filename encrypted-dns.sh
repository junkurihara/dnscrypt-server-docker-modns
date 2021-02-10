#! /usr/bin/env bash

CONF_DIR="/opt/encrypted-dns/etc"
KEYS_DIR="/opt/encrypted-dns/etc/keys"
CONFIG_FILE="${CONF_DIR}/encrypted-dns.toml"
LOG_FILE=/var/log/dnscrypt-server/dnscrypt-server.log

if [ ! -f "$KEYS_DIR/provider_name" ]; then
    exit 1
fi

chown -R _encrypted-dns:_encrypted-dns /opt/dnscrypt-wrapper/etc/keys 2>/dev/null || :
chown -R _encrypted-dns:_encrypted-dns /opt/encrypted-dns/etc/keys 2>/dev/null || :

if [ -f /opt/encrypted-dns/etc/.env ]; then
  source /opt/encrypted-dns/etc/.env
fi

if [ $DEBUG ]; then
  RUST_LOG=debug exec /opt/encrypted-dns/sbin/encrypted-dns --config "$CONFIG_FILE" | tee $LOG_FILE
else
  RUST_LOG=info exec /opt/encrypted-dns/sbin/encrypted-dns --config "$CONFIG_FILE" | tee $LOG_FILE
fi
# exec /opt/encrypted-dns/sbin/encrypted-dns --config "$CONFIG_FILE"
