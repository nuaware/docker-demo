#!/bin/bash

push_images() {
    echo; echo "Docker login:"
    docker login

    for image in $*; do
        echo; echo "push $image"
        docker push $image
    done
}

build_image() {
    TXT_IMAGE=$1; shift
    PNG_IMAGE=$1; shift
    IMAGE_NAME=$1; shift

    IMAGE_VERSION=${IMAGE_NAME#*:}

    echo; echo "---- Building image $IMAGE_NAME"
    sed -e "s/REPLACE_LOGO/$TXT_IMAGE/" \
        -e "s/IMAGE_VERSION/$IMAGE_VERSION/" \
        demo-main-go.tmpl > main.go
    sed "s/REPLACE_LOGO/$PNG_IMAGE/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl
    set -x
    docker build -t $IMAGE_NAME .
    set +x
}

VERSIONS=6

build_image "docker_blue.txt"   "docker_blue.png"   mjbright/docker-demo:1
build_image "docker_green.txt"  "docker_green.png"  mjbright/docker-demo:2
build_image "docker_red.txt"    "docker_red.png"    mjbright/docker-demo:3
build_image "docker_yellow.txt" "docker_yellow.png" mjbright/docker-demo:4
build_image "docker_cyan.txt"   "docker_cyan.png"   mjbright/docker-demo:5
build_image "docker_white.txt"  "docker_white.png"  mjbright/docker-demo:6

build_image "kubernetes_blue.txt"   "kubernetes_blue.png"   mjbright/k8s-demo:1
build_image "kubernetes_green.txt"  "kubernetes_green.png"  mjbright/k8s-demo:2
build_image "kubernetes_red.txt"    "kubernetes_red.png"    mjbright/k8s-demo:3
build_image "kubernetes_yellow.txt" "kubernetes_yellow.png" mjbright/k8s-demo:4
build_image "kubernetes_cyan.txt"   "kubernetes_cyan.png"   mjbright/k8s-demo:5
build_image "kubernetes_white.txt"  "kubernetes_white.png"  mjbright/k8s-demo:6

IMAGES=""
for image in mjbright/docker-demo mjbright/k8s-demo; do
   for version in $(seq $VERSIONS); do
       IMAGES+="${image}:${version} "
   done
done

push_images $IMAGES

exit 0


