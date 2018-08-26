FROM node:8-slim
MAINTAINER Said Sef <saidsef@gmail.com> (saidsef.co.uk/)

ARG PORT=""

ENV DEBIAN_FRONTEND noninteractive
ENV PORT ${PORT:-9099}

WORKDIR /app

RUN apt-get update && \
    apt-get --no-install-recommends -yq install build-essential git curl python3 python2.7 && \
    useradd -ms /bin/bash cloud9 && \
    chown -R cloud9 /app

USER cloud9

RUN  git clone --depth 2 https://github.com/c9/core.git . && \ 
    ./scripts/install-sdk.sh && \
    mkdir -p workspace

VOLUME ["/app/workspace"]

EXPOSE ${PORT}

CMD /usr/local/bin/node server.js -a : --listen 0.0.0.0 -p ${PORT} -w ./workspace --collab --no-cache
