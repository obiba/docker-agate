#
# Docker helper
#

no_cache=true
export tag=snapshot

docker_compose_file=docker-compose.yml

up:
	docker compose -f $(docker_compose_file) up -d --remove-orphans

down:
	docker compose -f $(docker_compose_file) down

stop:
	docker compose -f $(docker_compose_file) stop

start:
	docker compose -f $(docker_compose_file) start

restart:
	docker compose -f $(docker_compose_file) restart

pull:
	docker compose -f $(docker_compose_file) pull --include-deps

logs:
	docker compose -f $(docker_compose_file) logs -f

build:
	docker compose -f $(docker_compose_file) build --no-cache

# Build Docker image
build-image:
	docker build --pull --no-cache=$(no_cache) -t="obiba/agate:$(tag)" .

push-image:
	docker image push obiba/agate:$(tag)

clean:
	rm -rf target
