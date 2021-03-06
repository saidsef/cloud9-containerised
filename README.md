# Cloud9 Containerised

This will build and containerise the core repository for the [Cloud9 v3 SDK](https://github.com/c9/core). The SDK allows you to run a version of Cloud9 that allows you to develop plugins and create a custom IDE based on Cloud9.

## Installation

Follow these steps to build:

```shell
git clone https://github.com/saidsef/cloud9-containerised
```

```shell
docker build -t cloud9:dev .
```

```shell
docker run -d -p 9099:9099 -v /path/to/workspace:/app/workspace cloud9:dev
```

## Deployment

To deploy (without building it locally):

```shell
docker pull saidsef/cloud9-containerised
```

```shell
docker run -d -p 9099:9099 -v /path/to/workspace:/app/workspace saidsef/cloud9-containerised
```
### Kubernetes

> Remeber to update `deployment/ingress.yml` hostname to deploy and access the services

```shell
kubectl apply -k deployment/
```