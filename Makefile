#
# Docker helper
#

no_cache=false

# Build Docker image
build:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:snapshot" .

build-version:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:$(version)" $(version)

build-branch:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:branch-snapshot" branch-snapshot 