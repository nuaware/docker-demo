#!/bin/bash

push_images() {
    echo; echo "Docker login:"
    docker login

    for image in $*; do
        echo; echo "push $image"
        docker push $image
    done
}

UNUSED_build_image2() {
    TXT_IMAGE=$1; shift
    PNG_IMAGE=$1; shift
    IMAGE_NAME=$1; shift
    IMAGE_NAME_2x=$1; shift

    echo; echo "---- Building image $IMAGE_NAME (and tag $IMAGE_NAME_2x)"
    sed "s/REPLACE_LOGO/$TXT_IMAGE/" demo-main-go.tmpl > main.go
    sed "s/REPLACE_LOGO/$PNG_IMAGE/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl
    set -x
    docker build -t $IMAGE_NAME .
    docker tag      $IMAGE_NAME $IMAGE_NAME_2x
    set +x
}

build_image() {
    TXT_IMAGE=$1; shift
    PNG_IMAGE=$1; shift
    IMAGE_NAME=$1; shift

    echo; echo "---- Building image $IMAGE_NAME"
    sed "s/REPLACE_LOGO/$TXT_IMAGE/" demo-main-go.tmpl > main.go
    sed "s/REPLACE_LOGO/$PNG_IMAGE/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl
    set -x
    docker build -t $IMAGE_NAME .
    set +x
}

#build_image2 "docker_blue.txt" "docker_blue.png" mjbright/docker-demo:1 mjbright/docker-demo:20
#build_image2 "docker_red.txt"  "docker_red.png"  mjbright/docker-demo:2 mjbright/docker-demo:21

#build_image2 "kubernetes_blue.txt" "kubernetes_blue.png" mjbright/k8s-demo:1 mjbright/k8s-demo:20
#build_image2 "kubernetes_red.txt"  "kubernetes_red.png"  mjbright/k8s-demo:2 mjbright/k8s-demo:21

build_image "docker_blue.txt"   "docker_blue.png"   mjbright/docker-demo:1
build_image "docker_green.txt"  "docker_green.png"  mjbright/docker-demo:2
build_image "docker_red.txt"    "docker_red.png"    mjbright/docker-demo:3
build_image "docker_yellow.txt" "docker_yellow.png" mjbright/docker-demo:4

build_image "kubernetes_blue.txt"   "kubernetes_blue.png"   mjbright/k8s-demo:1
build_image "kubernetes_green.txt"  "kubernetes_green.png"  mjbright/k8s-demo:2
build_image "kubernetes_red.txt"    "kubernetes_red.png"    mjbright/k8s-demo:3
build_image "kubernetes_yellow.txt" "kubernetes_yellow.png" mjbright/k8s-demo:4

push_images mjbright/docker-demo:1 mjbright/docker-demo:2 mjbright/docker-demo:3 mjbright/docker-demo:4 \
            mjbright/k8s-demo:1 mjbright/k8s-demo:2 mjbright/k8s-demo:3 mjbright/k8s-demo:4

exit 0


