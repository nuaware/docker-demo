#!/bin/bash

press() {
    echo $*
    echo "Press <return>"
    read
}

OLD() {
  for image in mjbright/docker-demo:1 mjbright/docker-demo:2 mjbright/k8s-demo:1 mjbright/k8s-demo:2; do
    echo "Testing image $image"
    docker run -d -p 8080:8080 $image
    ID=$(docker ps -ql)

    [ -z "$ID" ] && { echo "ERROR: Failed to launch container"; continue; }

    sleep 1
    curl 127.0.0.1:8080
    press
    curl 127.0.0.1:8080/ping
    press
    curl 127.0.0.1:8080/map
    press

    docker stop $ID; docker rm $ID; 
  done
}

VERSIONS=6


for image in mjbright/docker-demo mjbright/k8s-demo; do
    BASE_PORT=9100
    [ $image = "mjbright/docker-demo" ] && BASE_PORT=9000

    for version in $(seq $VERSIONS); do
        let PORT=BASE_PORT+version

        docker pull $image:$version
        docker run --rm -p ${PORT}:8080 -d $image:$version
    done
done



