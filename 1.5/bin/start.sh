#!/bin/bash

# Make sure conf folder is available
if [ ! -d $AGATE_HOME/conf ]
	then
	mkdir -p $AGATE_HOME/conf
	cp -r /usr/share/agate/conf/* $AGATE_HOME/conf
fi

# Check if 1st run. Then configure application.
if [ -e /opt/agate/bin/first_run.sh ]
    then
    /opt/agate/bin/first_run.sh
    mv /opt/agate/bin/first_run.sh /opt/agate/bin/first_run.sh.done
fi

# Wait for MongoDB to be ready
if [ -n "$MONGO_PORT_27017_TCP_ADDR" ]
	then
	until curl -i http://$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/agate &> /dev/null
	do
  		sleep 1
	done
fi

# Start agate
/usr/share/agate/bin/agate