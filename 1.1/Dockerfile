#
# Mica Dockerfile
#
# https://github.com/obiba/docker-mica
#

# Pull base image
FROM java:8

MAINTAINER OBiBa <dev@obiba.org>

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& wget -q -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -q -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

ENV AGATE_ADMINISTRATOR_PASSWORD=password
ENV AGATE_HOME=/srv
ENV JAVA_OPTS=-Xmx2G

ENV AGATE_VERSION 1.1.3

# Install Agate Python Client
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https unzip

RUN \
  wget -q -O - https://pkg.obiba.org/obiba.org.key | apt-key add - && \
  echo 'deb https://pkg.obiba.org stable/' | tee /etc/apt/sources.list.d/obiba.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y agate-python-client=$(apt-cache madison agate-python-client | cut -d ' ' -f 3 | grep ${AGATE_VERSION})

# Install Agate Server
RUN set -x && \
  cd /usr/share/ && \
  wget -q -O agate.zip https://download.obiba.org/agate/stable/agate-${AGATE_VERSION}-dist.zip && \
  unzip -q agate.zip && \
  rm agate.zip && \
  mv agate-dist-${AGATE_VERSION} agate

RUN chmod +x /usr/share/agate/bin/agate

COPY ./bin /opt/agate/bin

RUN chmod +x -R /opt/agate/bin
RUN adduser --system --home $AGATE_HOME --no-create-home --disabled-password agate
RUN chown -R agate /opt/agate

VOLUME /srv

# http and https
EXPOSE 8082 8444

# Define default command.
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]