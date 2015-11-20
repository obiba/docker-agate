#!/bin/bash

# Configure administrator password
adminpw=$(echo -n $AGATE_ADMINISTRATOR_PASSWORD | xargs java -jar /usr/share/agate-*/tools/lib/obiba-password-hasher-*-cli.jar)
cat /etc/agate/shiro.ini | sed -e "s/^administrator\s*=.*,/administrator=$adminpw,/" > /tmp/shiro.ini && \
    mv /tmp/shiro.ini /etc/agate/shiro.ini

# Configure MongoDB
sed s/localhost:27017/$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/g /etc/agate/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/agate/application.yml

chown -R agate:adm /etc/agate