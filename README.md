# Cloud9 Containerised

This is the will build and containerise the core repository for the [Cloud9 v3 SDK](https://github.com/c9/core). The SDK allows you to run a version of Cloud9 that allows you to develop plugins and create a custom IDE based on Cloud9

## Installation

Follow these steps to build:

```shell
git clone https://github.com/saidsef/cloud9-containerised
```

```shell
docker build -t cloud9:dev .
```

```shell
docker run -d -p 9099:9099 cloud9:dev
```

## Deployment

To deploy (without building it locally):

```shell
docker pull saidsef/cloud9-containerised
```

```shell
docker run -d -p 9099:9099 saidsef/cloud9-containerised
```
