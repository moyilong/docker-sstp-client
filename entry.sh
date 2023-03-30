#!/usr/bin/env bash

set -e
set -a

if [ -z "$REMOTEHOST" ]; then
  echo "Variable REMOTEHOST must be set."; exit;
fi

# echo "$USER connection '$PASSWORD' *" | tee -a /etc/ppp/chap-secrets

sstpc_args=(
    "--user" "$USER"
    "--password" "$PASSWORD"
    "$REMOTEHOST"
    "--log-stdout"
    "--log-level" "4"
    "--tls-ext"
    "--save-server-route"
    "noauth"
    # "require-mppe"
    # "require-mschap-v2"
    "defaultroute"
)

sysctl net.ipv6.conf.all.disable_ipv6=1
sysctl net.ipv6.conf.default.disable_ipv6=1

# /etc/init.d/syslog-ng start

sstpc "${sstpc_args[@]}"

#pon connection

#sleep infinity