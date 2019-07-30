#!/bin/bash
set -e

if [ "$1" = 'app' ]; then
    chown -R agate "$AGATE_HOME"

    exec gosu agate /opt/agate/bin/start.sh
fi

exec "$@"
