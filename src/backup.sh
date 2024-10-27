#! /bin/sh

set -eu
set -o pipefail

source ./env.sh

echo "Creating backup of $POSTGRES_DB database..."

timestamp=$(date +"%Y-%m-%dT%H:%M:%S")
backup_filename="${timestamp}-${POSTGRES_DB}.dump"

pg_dump --format=custom \
        -h $POSTGRES_HOST \
        -p $POSTGRES_PORT \
        -U $POSTGRES_USER \
        -d $POSTGRES_DB \
        $PGDUMP_EXTRA_OPTS \
        -f "$backup_filename"

# Check if the dump was created successfully
if [ ! -f "$backup_filename" ]; then
    echo "Error: Backup file $backup_filename was not created."
    exit 1
fi

if [ -n "$PASSPHRASE" ]; then
  echo "Encrypting backup..."
  encrypted_filename="${backup_filename}.gpg"  # Encrypted filename with .gpg extension
  rm -f "$encrypted_filename"  # Remove old encrypted file if exists
  gpg --symmetric --batch --passphrase "$PASSPHRASE" "$backup_filename"
  rm "$backup_filename"  # Remove the unencrypted backup
  local_file="$encrypted_filename"  # Set the local file to the encrypted one
else
  local_file="$backup_filename"  # Use the original backup filename if no encryption
fi

echo "Uploading backup to $B2_BUCKET..."
./b2-linux file upload "${B2_BUCKET}" "$local_file" "${B2_PREFIX}/$local_file"
rm "$local_file"

echo "Backup complete."

# if [ -n "$BACKUP_KEEP_DAYS" ]; then
#   sec=$((86400*BACKUP_KEEP_DAYS))

#   echo "Removing old backups from $B2_BUCKET..."
#   cutoff=$(date -d "@$(($(date +%s) - sec))" +%s000)
#   ./b2-linux ls --recursive b2://${B2_BUCKET}/${B2_PREFIX} --json | jq --argjson cutoff "$cutoff" '.[] | select(.uploadTimestamp < $cutoff)'
#   echo "Removal complete."
# fi
