#!/bin/bash

# Legacy parameters
if [ -n "$MONGO_PORT_27017_TCP_ADDR" ]
then
	MONGO_HOST=$MONGO_PORT_27017_TCP_ADDR
fi
if [ -n "$MONGO_PORT_27017_TCP_PORT" ]
then
  MONGO_PORT=$MONGO_PORT_27017_TCP_PORT
fi

# Make sure conf folder is available
if [ ! -d $AGATE_HOME/conf ]
	then
		mkdir -p $AGATE_HOME/conf
		cp -r /usr/share/agate/conf/* $AGATE_HOME/conf
		# So that application is accessible from outside of docker
		sed s/address:\ localhost//g $AGATE_HOME/conf/application.yml > /tmp/application.yml && \
	    mv /tmp/application.yml $AGATE_HOME/conf/application.yml
fi

# Check if 1st run. Then configure application.
if [ -e /opt/agate/bin/first_run.sh ]
  then
  	/opt/agate/bin/first_run.sh
  	mv /opt/agate/bin/first_run.sh /opt/agate/bin/first_run.sh.done
fi

# Upgrade to 3.x
if [ -e $AGATE_HOME/conf/application.yml ]
	then
		if grep -q "profiles:" $AGATE_HOME/conf/application.yml
			then
				cp $AGATE_HOME/conf/application.yml $AGATE_HOME/conf/application.yml.2.x
				cat $AGATE_HOME/conf/application.yml.2.x | grep -v "profiles:" > $AGATE_HOME/conf/application.yml
		fi
fi

# Wait for MongoDB to be ready
if [ -n "$MONGO_HOST" ]
	then
	until curl -i http://$MONGO_HOST:$MONGO_PORT/agate &> /dev/null
	do
  		sleep 1
	done
fi

# Start agate
/usr/share/agate/bin/agate
