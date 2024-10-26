#! /bin/sh

set -eux
set -o pipefail

apk update

# install pg_dump
apk add postgresql-client wget gnupg jq

wget https://github.com/Backblaze/B2_Command_Line_Tool/releases/latest/download/b2-linux

chmod +x b2-linux

# install go-cron
apk add curl
curl -L https://github.com/ivoronin/go-cron/releases/download/v0.0.5/go-cron_0.0.5_linux_${TARGETARCH}.tar.gz -O
tar xvf go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
rm go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
mv go-cron /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron
apk del curl

# cleanup
rm -rf /var/cache/apk/*
