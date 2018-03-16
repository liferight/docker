# Docker PFN : PHP + PHP-FPM + NGINX

This repository contains a Dockerfile to build a Docker Image with PHP 7.x + PHP-FPM + Nginx compiled from the sources.

[![Build Status](https://travis-ci.org/zokeber/docker-pfn.svg?branch=master)](https://travis-ci.org/zokeber/docker-pfn)

## Base Docker Image

* [zokeber/centos](https://registry.hub.docker.com/u/zokeber/centos/)

## Usage

### Installation

1. Install [Docker](https://www.docker.com/).

2. To create the image zokeber/docker-pfn, clone this repository and execute the following command on the docker-pfn folder:

`docker build --build-arg DOMAIN=app.domain.com --build-arg NGINX=1.10.3 --build-arg PHP=7.0.17 -t zokeber/pfn:latest .`

### Create and running a container

**Create container:**

```
docker create -it -p 80:80 --restart=always --name php7-fpm-nginx -h php7-fpm-nginx zokeber/pfn
```

**Start container:**

```
docker start php7-fpm-nginx
```

### Connection methods:

`docker exec -it php7-fpm-nginx bash`
