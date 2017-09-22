#!/bin/bash

docker run -d -p 8080:8080 mjbright/docker-demo:20
docker run -d -p 9090:8080 mjbright/docker-demo:21

curl 127.0.0.1:8080
#read

curl 127.0.0.1:9090
#read




