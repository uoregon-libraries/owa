#!/bin/bash
MAX_TRIES=15
TRIES=0
while true; do
  mysql -u$OWA_DB_USER -hdb -p$OWA_DB_PASSWORD -e "ALTER DATABASE $OWA_DB_NAME charset=utf8"
  st=$?
  if [[ $st == 0 ]]; then
    break
  fi

  let TRIES++
  if [[ $TRIES == $MAX_TRIES ]]; then
    echo "ERROR: Unable to connect to the database after $MAX_TRIES attempts"
    exit 2
  fi

  sleep 5
done
