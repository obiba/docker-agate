#
# Docker helper
#

no_cache=false

help:
	@echo "make build run-mongodb run stop clean"

#
# agate
#

# Build agate Docker image
build:
	docker build --no-cache=$(no_cache) -t="obiba/agate:snapshot" .

# Run a agate Docker instance
run:
	docker run -d -p 8844:8444 -p 8881:8081 --name agate --link mongodb:mongo obiba/agate:snapshot

# Run a agate Docker instance with shell
run-sh:
	docker run -ti -p 8844:8444 -p 8881:8081 --name agate --link mongodb:mongo obiba/agate:snapshot bash

# Show logs
logs:
	docker logs agate

# Stop a agate Docker instance
stop:
	docker stop agate

# Stop and remove a agate Docker instance
clean: stop
	docker rm agate

#
# MongoDB
#

# Run a Mongodb Docker instance
run-mongodb:
	docker run -d --name mongodb mongo

# Stop a Mongodb Docker instance
stop-mongodb:
	docker stop mongodb

# Stop and remove a Mongodb Docker instance
clean-mongodb: stop-mongodb
	docker rm mongodb

# Remove all images
clean-images:
	docker rmi -f `docker images -q`