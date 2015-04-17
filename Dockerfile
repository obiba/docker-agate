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
  wget -q -O - http://pkg.obiba.org/obiba.org.key | apt-key add - && \
  echo 'deb http://pkg.obiba.org unstable/' | tee /etc/apt/sources.list.d/obiba.list && \
  echo agate agate/admin_password select password | debconf-set-selections && \
  echo agate agate/admin_password_again select password | debconf-set-selections && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y agate agate-python-client

COPY bin /opt/agate/bin

RUN chmod +x -R /opt/agate/bin

# Define default command.
ENTRYPOINT ["bash", "-c", "/opt/agate/bin/start.sh"]

# http
EXPOSE 8081
# https
EXPOSE 8444
