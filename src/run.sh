#! /bin/sh

set -eu

# Authenticate with Backblaze B2 using the provided account ID and application key
./b2-linux account authorize "$B2_APPLICATION_KEY_ID" "$B2_APPLICATION_KEY"

if [ -z "$SCHEDULE" ]; then
  sh backup.sh
else
  exec go-cron "$SCHEDULE" /bin/sh backup.sh
fi
