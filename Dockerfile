#
# Agate Dockerfile
#
# https://github.com/obiba/docker-agate
#

FROM docker.io/library/eclipse-temurin:21-jre-noble AS server-released

LABEL OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

ENV AGATE_ADMINISTRATOR_PASSWORD=password
ENV AGATE_HOME=/srv
ENV JAVA_OPTS=-Xmx2G

ENV AGATE_VERSION 3.2.0

# Install Agate Python Client
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y gosu apt-transport-https unzip curl python3-pip libcurl4-openssl-dev libssl-dev && \
  apt-get clean &&  \
  rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages obiba-agate

# Install Agate Server
RUN set -x && \
  cd /usr/share/ && \
  wget -q -O agate.zip https://github.com/obiba/agate/releases/download/${AGATE_VERSION}/agate-${AGATE_VERSION}-dist.zip && \
  unzip -q agate.zip && \
  rm agate.zip && \
  mv agate-${AGATE_VERSION} agate

RUN chmod +x /usr/share/agate/bin/agate

COPY ./bin /opt/agate/bin

RUN chmod +x -R /opt/agate/bin && \
  adduser --system --home $AGATE_HOME --no-create-home --disabled-password agate && \
  chown -R agate /opt/agate

VOLUME /srv

# http and https
EXPOSE 8081 8444

# Define default command.
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
