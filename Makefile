#
# Docker helper
#

no_cache=false

# Build Docker image
build:
	docker build --no-cache=$(no_cache) -t="obiba/agate:$(tag)" .

push:
	docker image push obiba/agate:$(tag)
