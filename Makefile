#
# Docker helper
#

no_cache=false

# Build Docker image
build:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:snapshot" .

build12x:
	sudo docker build --no-cache=$(no_cache) -t="obiba/agate:1.2-snapshot" 1.2-snapshot 