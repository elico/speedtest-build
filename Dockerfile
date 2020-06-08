FROM golang:alpine AS build-env

LABEL maintainer "Eliezer Croitoru <ngtech1ltd@gmail.com>"

RUN apk add --no-cache curl git vim bash wget

RUN git clone https://github.com/miquels/speedtest /build/speedtest && \
    cd /build/speedtest/server && \
    go get -v -u github.com/gorilla/websocket && \
    CGO_ENABLED=0 go build server.go 


FROM debian:buster

RUN apt update && apt upgrade -y && \
	apt install build-essential -y && \
	apt install curl software-properties-common -y && \
	curl -sL https://deb.nodesource.com/setup_14.x -o /tmp/setup_14.x && \
	/bin/bash /tmp/setup_14.x && \
	curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt update && apt install yarn -y


RUN apt install git -y

COPY --from=build-env /build/speedtest/server/server /speedtest-server

CMD ["/build/build"]
