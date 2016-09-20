#
# Docker helper
#

no_cache=false

# Build Docker image
build:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:snapshot" .

build11:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:1.1" 1.1

build12:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:1.2" 1.2 

build-branch:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:branch-snapshot" branch-snapshot 