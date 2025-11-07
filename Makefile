#
# Docker helper
#

tag=snapshot
no_cache=true

# Build Docker image
build:
	docker build --pull --no-cache=$(no_cache) --progress=plain -t="obiba/agate:$(tag)" -f Dockerfile ..

push:
	docker image push obiba/agate:$(tag)

tag:
	docker image tag obiba/agate:$(tag) obiba/agate:$(tag2)