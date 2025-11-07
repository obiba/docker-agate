#
# Agate Dockerfile
#
# https://github.com/obiba/docker-agate
#

FROM docker.io/library/eclipse-temurin:25-jre-noble AS server-released

LABEL OBiBa=<dev@obiba.org>

ENV AGATE_ADMINISTRATOR_PASSWORD=password
ENV AGATE_HOME=/srv
ENV AGATE_DIST=/usr/share/agate
ENV JAVA_OPTS="-Xms1G -Xmx2G -XX:+UseG1GC"

ENV AGATE_VERSION=4.0-SNAPSHOT

WORKDIR /tmp
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y vim gosu daemon psmisc apt-transport-https unzip curl python3-pip libcurl4-openssl-dev libssl-dev && \
  apt-get clean &&  \
  rm -rf /var/lib/apt/lists/*

# Install Agate Server
COPY agate/agate-dist/target/agate-${AGATE_VERSION}-dist/agate-${AGATE_VERSION} /usr/share/agate

# Plugins dependencies
WORKDIR /projects

COPY docker-agate/bin /opt/agate/bin

RUN groupadd --system --gid 10041 agate && \
  useradd --system --home $AGATE_HOME --no-create-home --uid 10041 --gid agate agate; \
  chmod +x -R /opt/agate/bin && \
  chown -R agate /opt/agate

# Clean up
RUN apt remove -y curl && \
  apt autoremove -y && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR $AGATE_HOME

VOLUME $AGATE_HOME
EXPOSE 8081 8444

COPY docker-agate/docker-entrypoint.sh /
ENTRYPOINT ["/bin/bash" ,"/docker-entrypoint.sh"]
CMD ["app"]