#!/usr/bin/env bash
set -Eeu

if [[ (! -z "$APP_USER") &&  (! -z "$APP_PASSWORD") && (! -z "$APP_DATABASE")]]; then

  if [[ "$APP_USER" = "postgres" ]]; then
    echo "Updating postgres user with new password"
    psql "$1" -w -c "ALTER ROLE \"postgres\" WITH ENCRYPTED PASSWORD '${APP_PASSWORD}'"
  else
    echo "Creating user ${APP_USER}"
    psql "$1" -w -c "create user \"${APP_USER}\" WITH LOGIN ENCRYPTED PASSWORD '${APP_PASSWORD}'"
  fi

  echo "Creating database ${APP_DATABASE}"
  psql "$1" -w -c "CREATE DATABASE \"${APP_DATABASE}\" OWNER \"${APP_USER}\" ENCODING '${APP_DB_ENCODING:-UTF8}' LC_COLLATE = '${APP_DB_LC_COLLATE:-en_US.UTF-8}' LC_CTYPE = '${APP_DB_LC_CTYPE:-en_US.UTF-8}'"

else
  echo "Skipping user creation"
  echo "Skipping database creation"
fi
