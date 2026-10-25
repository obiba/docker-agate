#!/bin/bash
set -e

if [ "$1" = 'app' ]; then
    if [ "$(id -u)" = 0 ]; then
        chown -R agate:agate "$AGATE_HOME"
        exec gosu agate /opt/agate/bin/start.sh
    fi
    exec /opt/agate/bin/start.sh
fi

exec "$@"
