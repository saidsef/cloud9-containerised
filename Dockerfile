FROM node:8-slim
MAINTAINER Said Sef <saidsef@gmail.com> (saidsef.co.uk/)

ARG PORT="9099"
ARG AUTH=":"

ENV AUTH ${AUTH}
ENV DEBIAN_FRONTEND noninteractive
ENV PORT ${PORT}

WORKDIR /app

RUN apt-get update && \
    apt-get --no-install-recommends -yq install build-essential git curl python3 python2.7 && \
    mkdir -p /app/workspace && \
    useradd -m -d /app -s /bin/bash -U cloud9 && \
    chown -R cloud9:cloud9 /app

USER cloud9

RUN  git clone --depth 2 https://github.com/c9/core.git c9sdk && \ 
    ./c9sdk/scripts/install-sdk.sh

VOLUME ["/app/workspace"]

EXPOSE ${PORT}

CMD /usr/local/bin/node c9sdk/server.js -a ${AUTH} -l 0.0.0.0 -p ${PORT} -w ./workspace --collab --no-cache
