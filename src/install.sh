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
curl -L https://github.com/JasonShuyinta/postgres-backup-b2/releases/download/v1.0.0/go-cron -O
mv go-cron /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron
apk del curl

# cleanup
rm -rf /var/cache/apk/*
