#!/bin/bash

press() {
    echo $*
    echo "Press <return>"
    read
}

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


