#
# Build project in separate container
#

FROM golang:alpine3.13 AS build

RUN apk update && \
    apk upgrade && \
    apk add git
COPY . /go/src/github.com/slysmoke/static-data

WORKDIR /go/src/github.com/slysmoke/static-data
RUN go mod init github.com/slysmoke/static-data
RUN go get github.com/go-redis/redis/v8
RUN go get go.opentelemetry.io/otel/label
RUN go get -d -v ./...
RUN go build
RUN cp /go/src/github.com/slysmoke/static-data/static-data /static-data




FROM alpine:3.7

#
# Copy release to container and set command
#

# Add faster mirror and upgrade packages in base image, load ca certs, otherwise no TLS for us
RUN printf "https://mirror.leaseweb.com/alpine/v3.7/main\nhttps://mirror.leaseweb.com/alpine/v3.7/community" > etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add ca-certificates && \
    rm -rf /var/cache/apk/*

RUN addgroup -g 1000 -S element43 && \
    adduser -u 1000 -S element43 -G element43 && \
    mkdir /data && \
    chown -R element43:element43 /data

# Do not run as root
USER element43:element43

# Copy build
COPY --from=build /static-data /static-data



ENV PORT 43000
EXPOSE 43000

CMD ["/static-data"]