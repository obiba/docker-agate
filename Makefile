#
# Docker helper
#

no_cache=false

all:
	sudo docker build --no-cache=true -t="obiba/agate:$(tag)" . && \
		sudo docker build -t="obiba/agate:latest" . && \
		sudo docker image push obiba/agate:$(tag) && \
		sudo docker image push obiba/agate:latest

# Build Docker image
build:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:$(tag)" .

push:
	sudo docker image push obiba/agate:$(tag)
