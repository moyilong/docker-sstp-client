#!/usr/bin/env bash

set -e
set -a

if [ -z "$REMOTEHOST" ]; then
  echo "Variable REMOTEHOST must be set."; exit;
fi

# echo "$USER connection '$PASSWORD' *" | tee -a /etc/ppp/chap-secrets


if [ ! "$MODPROBE" == "" ]; then
  modprobe ppp_generic
fi

sstpc_args=(
    "--user" "$USER"
    "--password" "$PASSWORD"
    "$REMOTEHOST"
    "--log-stdout"
    "--log-level" "4"
    "--tls-ext"
    "--cert-warn"
    "--save-server-route"
    "--ca-path /etc/ssl/certs/"
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