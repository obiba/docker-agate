#!/bin/bash

# Check if 1st run. Then configure database.
if [ -e /opt/agate/bin/first_run.sh ]
    then
    /opt/agate/bin/first_run.sh
    mv /opt/agate/bin/first_run.sh /opt/agate/bin/first_run.sh.done
fi

# Wait for MongoDB to be ready
until curl -i http://$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/agate
do
  echo "."
done

# Start service
service agate start

# Wait for service to be ready
sleep 2

# Tail the log
tail -f /var/log/agate/agate.log