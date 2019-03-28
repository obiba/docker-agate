#
# Mica Dockerfile
#
# https://github.com/obiba/docker-mica
#

FROM obiba/docker-gosu:latest AS gosu

FROM openjdk:8-jdk-stretch AS server-released

LABEL OBiBa <dev@obiba.org>

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

ENV AGATE_ADMINISTRATOR_PASSWORD=password
ENV AGATE_HOME=/srv
ENV JAVA_OPTS=-Xmx2G

ENV AGATE_VERSION 1.4.6

# Install Agate Python Client
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https unzip

RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61 && \
  echo 'deb https://dl.bintray.com/obiba/deb all main' | tee /etc/apt/sources.list.d/obiba.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y agate-python-client

# Install Agate Server
RUN set -x && \
  cd /usr/share/ && \
  wget -q -O agate.zip https://github.com/obiba/agate/releases/download/${AGATE_VERSION}/agate-${AGATE_VERSION}-dist.zip && \
  unzip -q agate.zip && \
  rm agate.zip && \
  mv agate-${AGATE_VERSION} agate

COPY --from=gosu /usr/local/bin/gosu /usr/local/bin/

RUN chmod +x /usr/share/agate/bin/agate

COPY ./bin /opt/agate/bin

RUN chmod +x -R /opt/agate/bin
RUN adduser --system --home $AGATE_HOME --no-create-home --disabled-password agate
RUN chown -R agate /opt/agate

VOLUME /srv

# http and https
EXPOSE 8081 8444

# Define default command.
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["app"]
