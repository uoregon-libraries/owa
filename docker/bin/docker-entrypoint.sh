#!/bin/bash

echo $@

for f in /docker-entrypoint/*; do
	case "$f" in
		*.sh)	echo "$0: running $f"; . "$f" ;;
		*)		echo "$0: ignoring $f" ;;
	esac
	echo
done

exec "$@"
