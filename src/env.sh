if [ -z "$B2_BUCKET" ]; then
  echo "You need to set the B2_BUCKET environment variable."
  exit 1
fi

if [ -z "$POSTGRES_DATABASE" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ -z "$POSTGRES_HOST" ]; then
  # https://docs.docker.com/network/links/#environment-variables
  if [ -n "$POSTGRES_PORT_5432_TCP_ADDR" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ -z "$POSTGRES_USER" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ -z "$POSTGRES_PASSWORD" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable."
  exit 1
fi

if [ -n "$B2_ACCOUNT_ID"]; then 
  export B2_ACCOUNT_ID=$B2_ACCOUNT_ID
else 
  echo "You need to set the B2_ACCOUNT_ID env variable"
  exit 1
fi

if [ -n "$B2_APPLICATION_KEY"]; then
  export B2_APPLICATION_KEY=$B2_APPLICATION_KEY
else 
  echo "You need to set the B2_APPLICATION_KEY env variable"
  exit 1
fi 

export PGPASSWORD=$POSTGRES_PASSWORD
