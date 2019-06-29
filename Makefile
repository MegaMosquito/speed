all: build run

build:
	docker build -t speed .

dev: build
	-docker rm -f speed 2> /dev/null || :
	docker run -it --privileged -e MY_SECONDS_BETWEEN_TESTS=600 --name speed --net=host -p 5659:5659 --volume `pwd`:/outside speed /bin/sh

run:
	-docker rm -f speed 2>/dev/null || :
	docker run -d --restart unless-stopped --privileged -e MY_SECONDS_BETWEEN_TESTS=600 --name speed --net=host --volume `pwd`:/outside speed

test:
	curl -sS http://localhost:5659/v1/speed | jq .

exec:
	docker exec -it speed /bin/sh

stop:
	-docker rm -f speed 2>/dev/null || :

clean: stop
	-docker rmi speed 2>/dev/null || :

.PHONY: all build dev run exec stop clean
