FROM node:11-slim
MAINTAINER Said Sef <saidsef@gmail.com> (saidsef.co.uk/)

ARG PORT="9099"
ARG AUTH=":"

ENV AUTH ${AUTH}
ENV DEBIAN_FRONTEND noninteractive
ENV GOALNG_VERSION 1.12.10
ENV GOLANG_DEB 0.5.4
ENV GOROOT /usr/local/go
ENV PORT ${PORT}

WORKDIR /app

RUN apt-get update && \
    apt-get --no-install-recommends --force-yes -yq install \
    apt-transport-https ca-certificates gnupg2 software-properties-common \
    build-essential git curl locales && \
    locale-gen "en_US.UTF-8" && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    curl -fsSL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash && \
    apt-get update && \
    apt-get --no-install-recommends --force-yes -yq install \
    python3 python3-pip python3-dev python2.7 python-pip python-daemon python-dev jq docker-ce graphviz imagemagick mercurial && \
    echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    locale-gen en_US.UTF-8 && \
    cd /tmp && \
    curl -LO https://dl.google.com/go/go${GOALNG_VERSION}.linux-amd64.tar.gz && \
    curl -LO https://github.com/golang/dep/releases/download/v${GOLANG_DEB}/dep-linux-amd64 && \
    tar xf go${GOALNG_VERSION}.linux-amd64.tar.gz && \
    mv go /usr/local && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt && \
    mv dep-linux-amd64 /usr/local/bin/go-deb && \
    chmod a+x /usr/local/bin/go-deb && \
    rm -rf /tmp/* && \
    /usr/bin/pip3 install -U botocore boto3 && \
    mkdir -p /app/workspace && \
    useradd -m -d /app -s /bin/bash -U cloud9 && \
    usermod -aG docker cloud9 && \
    chown -R cloud9:cloud9 /app

USER cloud9

RUN  git clone --depth 2 https://github.com/c9/core.git c9sdk && \ 
    ./c9sdk/scripts/install-sdk.sh && \
    git config --global credential.helper 'cache --timeout=300'

VOLUME ["/app/workspace"]

EXPOSE ${PORT}

CMD /usr/local/bin/node c9sdk/server.js -a ${AUTH} -l 0.0.0.0 -p ${PORT} -w ./workspace --collab --no-cache
