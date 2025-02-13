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

# Configure administrator password
adminpw=$(echo -n $AGATE_ADMINISTRATOR_PASSWORD | xargs java -jar /usr/share/agate/tools/lib/obiba-password-hasher-*-cli.jar)
cat $AGATE_HOME/conf/shiro.ini | sed -e "s,^administrator\s*=.*\,,administrator=$adminpw\,," > /tmp/shiro.ini && \
    mv /tmp/shiro.ini $AGATE_HOME/conf/shiro.ini

# Configure MongoDB
if [ -n "$MONGODB_URI" ]
then
	sed s,localhost:27017/agate,$MONGODB_URI,g $AGATE_HOME/conf/application-prod.yml > /tmp/application-prod.yml
	mv -f /tmp/application-prod.yml $AGATE_HOME/conf/application-prod.yml
elif [ -n "$MONGO_HOST" ]
	then
  MGP=27017
	if [ -n "$MONGO_PORT" ]
	then
		MGP=$MONGO_PORT
	fi
	MGDB=agate
	if [ -n "$MONGO_DB" ]
	then
		MGDB=$MONGO_DB
	fi
	MGURI="$MONGO_HOST:$MGP"
	if [ -n "$MONGO_USER" ] && [ -n "$MONGO_PASSWORD" ]
	then
		MGURI="$MONGO_USER:$MONGO_PASSWORD@$MGURI/$MGDB?authSource=admin"
	else
		MGURI="$MGURI/$MGDB"
	fi
	sed s,localhost:27017/agate,$MGURI,g $AGATE_HOME/conf/application-prod.yml > /tmp/application-prod.yml
	mv -f /tmp/application-prod.yml $AGATE_HOME/conf/application-prod.yml
fi

# Configure ReCaptcha
if [ -n "$RECAPTCHA_SITE_KEY" -a -n "$RECAPTCHA_SECRET_KEY" ]
	then
	sed s/secret:\ 6Lfo7gYT.*/secret:\ $RECAPTCHA_SECRET_KEY/ $AGATE_HOME/conf/application-prod.yml | \
	sed s/reCaptchaKey:.*/reCaptchaKey:\ $RECAPTCHA_SITE_KEY/ > /tmp/application-prod.yml
	mv -f /tmp/application-prod.yml $AGATE_HOME/conf/application-prod.yml
fi
