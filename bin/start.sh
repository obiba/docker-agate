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
		sed s/address:\ localhost//g $AGATE_HOME/conf/application-prod.yml > /tmp/application-prod.yml && \
	    mv /tmp/application-prod.yml $AGATE_HOME/conf/application-prod.yml
fi

# Upgrade configuration
if [[ -f $AGATE_HOME/conf/application.yml && ! -f $AGATE_HOME/conf/application-prod.yml ]]
	then
	if grep -q "profiles:" $AGATE_HOME/conf/application.yml
		then
			cp $AGATE_HOME/conf/application.yml $AGATE_HOME/conf/application.yml.2.x
			cat $AGATE_HOME/conf/application.yml.2.x | grep -v "profiles:" > $AGATE_HOME/conf/application.yml
	fi
	mv -f $AGATE_HOME/conf/application.yml $AGATE_HOME/conf/application-prod.yml
fi

# Check if 1st run. Then configure application.
if [ ! -e $AGATE_HOME/.first_run.sh.done ]
  then
  	/opt/agate/bin/first_run.sh
  	touch $AGATE_HOME/.first_run.sh.done
fi

# Start agate
echo "Starting Agate..."
exec /usr/share/agate/bin/agate