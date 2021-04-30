#!/bin/bash
MAX_TRIES=15
TRIES=0
while true; do
  mysqladmin status -hdb -u$OWA_DB_USER -p$OWA_DB_PASSWORD
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
