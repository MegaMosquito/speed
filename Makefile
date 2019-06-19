all: build run

build:
	docker build -t speedtest .

dev: build
	-docker rm -f speedtest 2> /dev/null || :
	docker run -it --privileged -e MY_SECONDS_BETWEEN_TESTS=600 --name speedtest --net=host -p 5659:5659 --volume `pwd`:/outside speedtest /bin/sh

run:
	-docker rm -f speedtest 2>/dev/null || :
	docker run -d --privileged -e MY_SECONDS_BETWEEN_TESTS=600 --name speedtest --net=host --volume `pwd`:/outside speedtest

test:
	curl -sS http://localhost:5659/v1/speedtest | jq .

exec:
	docker exec -it speedtest /bin/sh

stop:
	-docker rm -f speedtest 2>/dev/null || :

clean: stop
	-docker rmi speedtest 2>/dev/null || :

.PHONY: all build dev run exec stop clean
