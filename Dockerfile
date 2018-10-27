FROM node:8-slim
MAINTAINER Said Sef <saidsef@gmail.com> (saidsef.co.uk/)

ARG PORT="9099"
ARG AUTH=":"

ENV AUTH ${AUTH}
ENV DEBIAN_FRONTEND noninteractive
ENV PORT ${PORT}

WORKDIR /app

RUN apt-get update && \
    apt-get --no-install-recommends -yq install \
    apt-transport-https ca-certificates gnupg2 software-properties-common \
    build-essential git curl && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    curl -fsSL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash && \
    apt-get update && \
    apt-get --no-install-recommends -yq install \
    python3 python3-pip python3-dev python2.7 python-pip python-daemon python-dev jq docker-ce && \
    /usr/bin/pip3 install -U botocore boto3 && \
    mkdir -p /app/workspace && \
    useradd -m -d /app -s /bin/bash -U cloud9 && \
    usermod -aG docker cloud9 && \
    chown -R cloud9:cloud9 /app

USER cloud9

RUN  git clone --depth 2 https://github.com/c9/core.git c9sdk && \ 
    ./c9sdk/scripts/install-sdk.sh

VOLUME ["/app/workspace"]

EXPOSE ${PORT}

CMD /usr/local/bin/node c9sdk/server.js -a ${AUTH} -l 0.0.0.0 -p ${PORT} -w ./workspace --collab --no-cache
