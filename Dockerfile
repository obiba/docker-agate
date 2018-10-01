#
# agate Dockerfile
#
# https://github.com/obiba/docker-agate
#

FROM debian:stretch-slim AS gosu

# grab gosu for easy step-down from root
# see https://github.com/tianon/gosu/blob/master/INSTALL.md
ENV GOSU_VERSION 1.10
RUN set -ex; \
	\
	fetchDeps=' \
		ca-certificates \
    gnupg2 \
    dirmngr \
		wget \
	'; \
	apt-get update; \
	apt-get install -y --no-install-recommends $fetchDeps; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
	\
  # verify the signature
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
	gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
	rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
	\
	chmod +x /usr/local/bin/gosu; \
  # verify that the binary works
	gosu nobody true; \
	\
	apt-get purge -y --auto-remove $fetchDeps

FROM maven:3.5.4-slim AS building

ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 4.5.0
ENV AGATE_BRANCH master

RUN mkdir -p $NVM_DIR

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends devscripts debhelper build-essential fakeroot git && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
    source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    npm install -g bower grunt && \
    echo '{ "allow_root": true }' > $HOME/.bowerrc

WORKDIR /projects
RUN git clone https://github.com/obiba/agate.git

WORKDIR /projects/agate

RUN source $NVM_DIR/nvm.sh; \
    git checkout $AGATE_BRANCH; \
    mvn clean install && \
    mvn -Prelease org.apache.maven.plugins:maven-antrun-plugin:run@make-deb

FROM openjdk:8-jdk-stretch AS server

ENV AGATE_ADMINISTRATOR_PASSWORD password
ENV AGATE_HOME /srv
ENV JAVA_OPTS -Xmx2G

WORKDIR /tmp
COPY --from=building /projects/agate/agate-dist/target/agate_*.deb .
RUN apt-get update && \
    apt-get install -y --no-install-recommends daemon psmisc && \
    DEBIAN_FRONTEND=noninteractive dpkg -i agate_*.deb

COPY --from=gosu /usr/local/bin/gosu /usr/local/bin/

COPY /bin /opt/agate/bin
RUN chmod +x -R /opt/agate/bin; \
    chown -R agate /opt/agate; \
    chmod +x /usr/share/agate/bin/agate

VOLUME $AGATE_HOME
EXPOSE 8081 8444

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/bin/bash" ,"/docker-entrypoint.sh"]
CMD ["app"]
