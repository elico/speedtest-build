FROM rust AS build-env

LABEL maintainer "Eliezer Croitoru <ngtech1ltd@gmail.com>"

RUN git clone https://github.com/miquels/speedtest /build/speedtest && \
    cd /build/speedtest/server && \
    make


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

COPY --from=build-env /build/speedtest/server/speedtest-server /speedtest-server

CMD ["/build/build"]
