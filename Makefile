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
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:snapshot" .

# Run a agate Docker instance
run:
	sudo docker run -d -p 8844:8444 -p 8881:8081 --name agate --link mongodb:mongo obiba/agate:snapshot

# Run a agate Docker instance with shell
run-sh:
	sudo docker run -ti -p 8844:8444 -p 8881:8081 --name agate --link mongodb:mongo obiba/agate:snapshot bash

# Show logs
logs:
	sudo docker logs agate

# Stop a agate Docker instance
stop:
	sudo docker stop agate

# Stop and remove a agate Docker instance
clean: stop
	sudo docker rm agate

#
# MongoDB
#

# Run a Mongodb Docker instance
run-mongodb:
	sudo docker run -d --name mongodb mongo

# Stop a Mongodb Docker instance
stop-mongodb:
	sudo docker stop mongodb

# Stop and remove a Mongodb Docker instance
clean-mongodb: stop-mongodb
	sudo docker rm mongodb

# Remove all images
clean-images:
	sudo docker rmi -f `sudo docker images -q`