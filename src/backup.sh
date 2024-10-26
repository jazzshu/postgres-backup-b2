#! /bin/sh

set -eu
set -o pipefail

source ./env.sh

echo "Creating backup of $POSTGRES_DATABASE database..."
pg_dump --format=custom \
        -h $POSTGRES_HOST \
        -p $POSTGRES_PORT \
        -U $POSTGRES_USER \
        -d $POSTGRES_DATABASE \
        $PGDUMP_EXTRA_OPTS \
        > db.dump

timestamp=$(date +"%Y-%m-%dT%H:%M:%S")
b2_uri_base="b2://${B2_BUCKET}/${B2_PREFIX}/${POSTGRES_DATABASE}_${timestamp}.dump"

if [ -n "$PASSPHRASE" ]; then
  echo "Encrypting backup..."
  rm -f db.dump.gpg
  gpg --symmetric --batch --passphrase "$PASSPHRASE" db.dump
  rm db.dump
  local_file="db.dump.gpg"
  b2_uri="${b2_uri_base}.gpg"
else
  local_file="db.dump"
  b2_uri="$b2_uri_base"
fi

echo "Uploading backup to $B2_BUCKET..."
./b2-linux upload-file --noProgress "${B2_BUCKET}" "$local_file" "$b2_uri"
rm "$local_file"

echo "Backup complete."

if [ -n "$BACKUP_KEEP_DAYS" ]; then
  sec=$((86400*BACKUP_KEEP_DAYS))

  echo "Removing old backups from $B2_BUCKET..."
  cutoff=$(date -d "@$(($(date +%s) - sec))" +%s000)
  ./b2-linux ls --recursive b2://${B2_BUCKET}/${B2_PREFIX} --json | jq --argjson cutoff "$cutoff" '.[] | select(.uploadTimestamp < $cutoff)'
  echo "Removal complete."
fi
