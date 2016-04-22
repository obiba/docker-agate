#!/bin/bash
set -e

echo $1

if [ "$1" = 'app' ]; then
	chown -R agate /opt/agate
    chown -R agate "$AGATE_HOME"

    exec gosu agate /opt/agate/bin/start.sh
fi

exec "$@"
