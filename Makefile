all: up

up: build
	docker compose -f srcs/docker-compose.yaml up -d

build:
	docker compose -f srcs/docker-compose.yaml build

down:
	docker compose -f srcs/docker-compose.yaml down

clean:
	@if [ $$(docker ps -aq) ]; then docker rm -f $$(docker ps -aq); fi
	@if [ $$(docker images -q) ]; then docker rmi -f $$(docker images -q); fi
	@if [ $$(docker volume ls -q) ]; then docker volume rm $$(docker volume ls -q); fi
	@if [ $$(docker network ls -q | grep -v -e 'bridge' -e 'host' -e 'none') ]; then \
		docker network rm $$(docker network ls -q | grep -v -e 'bridge' -e 'host' -e 'none'); \
	fi
	docker system prune -a --volumes -f

