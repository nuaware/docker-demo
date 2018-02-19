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

CLEANUP() {
    RUNNING_DEMO_C=$(docker ps | grep -E "docker-demo|k8s-demo" | awk '{ print $1;}')
    [ ! -z "$RUNNING_DEMO_C" ] && {
        CMD="docker stop $RUNNING_DEMO_C"
        echo $CMD
        eval $CMD
    }

    STOPPED_DEMO_C=$(docker ps -a | grep -E "docker-demo|k8s-demo" | awk '{ print $1;}')
    [ ! -z "$STOPPED_DEMO_C" ] && {
        CMD="docker rm $STOPPED_DEMO_C"
        echo $CMD
        eval $CMD
    }
}

VERSIONS=6

CLEANUP

for image in mjbright/docker-demo mjbright/k8s-demo; do
    BASE_PORT=9100
    [ $image = "mjbright/docker-demo" ] && BASE_PORT=9000

    for version in $(seq $VERSIONS); do
        let PORT=BASE_PORT+version

        #docker pull $image:$version

        # expose container port on localhost:
        #docker run --rm -p ${PORT}:8080 -d $image:$version

        # expose listen on container port:
        #docker run --rm -d $image:$version -v -listen $PORT
        #docker run -d $image:$version -v -listen :$PORT

        # expose listen on container port and expose on localhost: quel interet?
        docker run --rm -d -p ${PORT}:${PORT} $image:$version -v -listen :$PORT
    done
done

