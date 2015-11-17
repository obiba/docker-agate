#
# agate Dockerfile
#
# https://github.com/obiba/docker-agate
#

# Pull base image
FROM java:8

MAINTAINER OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Install agate
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https && \
  wget -q -O - https://pkg.obiba.org/obiba.org.key | apt-key add - && \
  echo 'deb https://pkg.obiba.org unstable/' | tee /etc/apt/sources.list.d/obiba.list && \
  echo agate agate/admin_password select password | debconf-set-selections && \
  echo agate agate/admin_password_again select password | debconf-set-selections && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y agate agate-python-client

COPY bin /opt/agate/bin

RUN chmod +x -R /opt/agate/bin

# Define default command.
ENTRYPOINT ["/opt/agate/bin/start.sh"]

# http and https
EXPOSE 8081 8444
