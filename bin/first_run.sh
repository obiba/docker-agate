#!/bin/bash

# Configure MongoDB
sed s/localhost:27017/$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/g /etc/agate/application.yml > /tmp/application.yml
mv -f /tmp/application.yml /etc/agate/application.yml
chown -R agate:adm /etc/agate