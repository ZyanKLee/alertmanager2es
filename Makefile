.PHONY: build test

IMAGE_TAG=alertmanager2es:latest

build: test
	@# Ensure static binary build (no dynamic libs)
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 \
	  go build \
	  -ldflags '-w -extldflags "-static" -X main.revision=$(shell git describe --tags --always --dirty=-dev)'

test:
	go test $(go list ./... | grep -v /vendor/)

docker-build: clean
	docker build -t $(IMAGE_TAG) .

docker-run:
	docker run --rm $(IMAGE_TAG)

clean:
	rm -f alertmanager2es
