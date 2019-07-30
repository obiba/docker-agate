#!/bin/bash

# Configure administrator password
adminpw=$(echo -n $AGATE_ADMINISTRATOR_PASSWORD | xargs java -jar /usr/share/agate-*/tools/lib/obiba-password-hasher-*-cli.jar)
cat $AGATE_HOME/conf/shiro.ini | sed -e "s,^administrator\s*=.*\,,administrator=$adminpw\,," > /tmp/shiro.ini && \
    mv /tmp/shiro.ini $AGATE_HOME/conf/shiro.ini

# Configure MongoDB
if [ -n "$MONGO_PORT_27017_TCP_ADDR" ]
	then
	sed s/localhost:27017/$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/g $AGATE_HOME/conf/application.yml > /tmp/application.yml
	mv -f /tmp/application.yml $AGATE_HOME/conf/application.yml
fi

# Configure ReCaptcha
if [ -n "$RECAPTCHA_SITE_KEY" -a -n "$RECAPTCHA_SECRET_KEY" ]
	then
	sed s/secret:\ 6Lfo7gYT.*/secret:\ $RECAPTCHA_SECRET_KEY/ $AGATE_HOME/conf/application.yml | \
	sed s/reCaptchaKey:.*/reCaptchaKey:\ $RECAPTCHA_SITE_KEY/ > /tmp/application.yml
	mv -f /tmp/application.yml $AGATE_HOME/conf/application.yml
fi
