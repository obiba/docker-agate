#
# Docker helper
#

no_cache=true

# Build Docker image
build:
	docker build --pull --no-cache=$(no_cache) -t="obiba/agate:$(tag)" .

push:
	docker image push obiba/agate:$(tag)
