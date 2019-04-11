#############################
# Multi-Stage Build

FROM golang:stretch as builder

RUN mkdir -p /go/src/github.com/cloudflare/alertmanager2es
COPY . /go/src/github.com/cloudflare/alertmanager2es
RUN cd /go/src/github.com/cloudflare/alertmanager2es && \
  make clean && \
  make build

#############################
# Final-Stage Build

FROM alpine:latest
MAINTAINER cloudflare

COPY --from=builder /go/src/github.com/cloudflare/alertmanager2es/alertmanager2es \
     /bin/alertmanager2es

EXPOSE 9097
ENTRYPOINT [ "/bin/alertmanager2es" ]
