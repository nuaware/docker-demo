#!/bin/bash

VERSIONS=6

#EXPOSE_PORT=4321
EXPOSE_PORT=80

CACHE="--no-cache"

################################################################################
# Functions:

die() {
    echo "$0: die - $*" >&2
    exit 1
}

push_images() {
    for image in $*; do
        echo; echo "push $image"
        docker push $image
    done
}

build_image() {
    TXT_IMAGE=$1; shift
    PNG_IMAGE=$1; shift
    IMAGE_NAME_VERSION=$1; shift
    LIVENESS=$1; shift
    READINESS=$1; shift
    # e.g. build_image "docker_blue.txt"   "docker_blue.png"   nuaware/docker-demo:1 "OK" "OK"

    IMAGE_VERSION=${IMAGE_NAME_VERSION#*:}

    echo; echo "---- Building image $IMAGE_NAME_VERSION [VERSION:$IMAGE_VERSION]"

    sed -e "s/TEMPLATE_REPLACE_LOGO/$TXT_IMAGE/" \
        -e "s?TEMPLATE_IMAGE_NAME_VERSION?$IMAGE_NAME_VERSION?" \
        -e "s/TEMPLATE_IMAGE_VERSION/$IMAGE_VERSION/" \
        -e "s/TEMPLATE_EXPOSE_PORT/$EXPOSE_PORT/" \
        -e "s/TEMPLATE_LIVENESS/$LIVENESS/" \
        -e "s/TEMPLATE_READINESS/$READINESS/" \
        demo-main-go.tmpl > main.go

    IMAGE_NAME=${IMAGE_NAME_VERSION%:*}
    USE_IMAGE_NAME=$(echo $IMAGE_NAME | sed -e 's?/?_?g')
    #echo "IMAGE_NAME_VERSION=${IMAGE_NAME_VERSION}"
    #echo "IMAGE_NAME=${IMAGE_NAME}"
    #echo "USE_IMAGE_NAME=${USE_IMAGE_NAME}"
    mkdir -p tmp
    DEST=tmp/main_${USE_IMAGE_NAME}_${IMAGE_VERSION}.go
    echo cp -a main.go $DEST
    cp -a main.go $DEST
    #exit 0

    sed "s/REPLACE_LOGO/$PNG_IMAGE/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl

    sed "s/EXPOSE_PORT/$EXPOSE_PORT/" Dockerfile.tmpl > Dockerfile
    sed "s/EXPOSE_PORT/$EXPOSE_PORT/" test.sh.tmpl > test.sh

    set -x
    docker build $CACHE -t $IMAGE_NAME_VERSION .
    set +x
}

################################################################################
# Main:

#DHUB_ARGS=""
#[ ! -z "$DHUB_USER" ] && DHUB_ARGS="$DHUB_ARGS -u $DHUB_USER"
echo; echo "Docker login:"
#docker login $DHUB_ARGS
if [ ! -z "$DHUB_PWD" ];then
    [ -z "$DHUB_USER" ] && die "Must set DHUB_USER if DHUB_PWD is used"

    echo "$DHUB_PWD" | docker login --username $DHUB_USER --password-stdin
else
    docker login
fi

IGNORE='''
build_image "docker_blue.txt"   "docker_blue.png"   nuaware/docker-demo:1 "OK" "OK"
build_image "docker_green.txt"  "docker_green.png"  nuaware/docker-demo:2 "OK" "OK"
build_image "docker_red.txt"    "docker_red.png"    nuaware/docker-demo:3 "OK" "OK"
build_image "docker_yellow.txt" "docker_yellow.png" nuaware/docker-demo:4 "OK" "OK"
build_image "docker_cyan.txt"   "docker_cyan.png"   nuaware/docker-demo:5 "OK" "OK"
build_image "docker_white.txt"  "docker_white.png"  nuaware/docker-demo:6 "OK" "OK"

build_image "docker_blue.txt"   "docker_blue.png"   nuaware/docker-demo:bad1 "50s" "20s"
build_image "docker_green.txt"  "docker_green.png"  nuaware/docker-demo:bad2 "50s" "20s"
build_image "docker_red.txt"    "docker_red.png"    nuaware/docker-demo:bad3 "50s" "20s"
build_image "docker_yellow.txt" "docker_yellow.png" nuaware/docker-demo:bad4 "50s" "20s"
build_image "docker_cyan.txt"   "docker_cyan.png"   nuaware/docker-demo:bad5 "50s" "20s"
build_image "docker_white.txt"  "docker_white.png"  nuaware/docker-demo:bad6 "50s" "20s"
'''

build_image "kubernetes_blue.txt"   "kubernetes_blue.png"   nuaware/k8s-demo:1 "OK" "OK"
build_image "kubernetes_green.txt"  "kubernetes_green.png"  nuaware/k8s-demo:2 "OK" "OK"
build_image "kubernetes_red.txt"    "kubernetes_red.png"    nuaware/k8s-demo:3 "OK" "OK"
build_image "kubernetes_yellow.txt" "kubernetes_yellow.png" nuaware/k8s-demo:4 "OK" "OK"
build_image "kubernetes_cyan.txt"   "kubernetes_cyan.png"   nuaware/k8s-demo:5 "OK" "OK"
build_image "kubernetes_white.txt"  "kubernetes_white.png"  nuaware/k8s-demo:6 "OK" "OK"

IGNORE='''
build_image "kubernetes_blue.txt"   "kubernetes_blue.png"   nuaware/k8s-demo:bad1 "50s" "20s"
build_image "kubernetes_green.txt"  "kubernetes_green.png"  nuaware/k8s-demo:bad2 "50s" "20s"
build_image "kubernetes_red.txt"    "kubernetes_red.png"    nuaware/k8s-demo:bad3 "50s" "20s"
build_image "kubernetes_yellow.txt" "kubernetes_yellow.png" nuaware/k8s-demo:bad4 "50s" "20s"
build_image "kubernetes_cyan.txt"   "kubernetes_cyan.png"   nuaware/k8s-demo:bad5 "50s" "20s"
build_image "kubernetes_white.txt"  "kubernetes_white.png"  nuaware/k8s-demo:bad6 "50s" "20s"

build_image "kubernetes_blue.txt"   "kubernetes_blue.png"   nuaware/ckad-demo:1 "OK" "OK"
build_image "kubernetes_green.txt"  "kubernetes_green.png"  nuaware/ckad-demo:2 "OK" "OK"
build_image "kubernetes_red.txt"    "kubernetes_red.png"    nuaware/ckad-demo:3 "OK" "OK"
build_image "kubernetes_yellow.txt" "kubernetes_yellow.png" nuaware/ckad-demo:4 "OK" "OK"
build_image "kubernetes_cyan.txt"   "kubernetes_cyan.png"   nuaware/ckad-demo:5 "OK" "OK"
build_image "kubernetes_white.txt"  "kubernetes_white.png"  nuaware/ckad-demo:6 "OK" "OK"

build_image "kubernetes_blue.txt"   "kubernetes_blue.png"   nuaware/ckad-demo:bad1 "50s" "20s"
build_image "kubernetes_green.txt"  "kubernetes_green.png"  nuaware/ckad-demo:bad2 "50s" "20s"
build_image "kubernetes_red.txt"    "kubernetes_red.png"    nuaware/ckad-demo:bad3 "50s" "20s"
build_image "kubernetes_yellow.txt" "kubernetes_yellow.png" nuaware/ckad-demo:bad4 "50s" "20s"
build_image "kubernetes_cyan.txt"   "kubernetes_cyan.png"   nuaware/ckad-demo:bad5 "50s" "20s"
build_image "kubernetes_white.txt"  "kubernetes_white.png"  nuaware/ckad-demo:bad6 "50s" "20s"
'''

#for version in $(seq $VERSIONS); do
#    docker tag nuaware/k8s-demo:$version  nuaware/ckad-demo:$version
#    docker tag nuaware/k8s-demo:bad$version  nuaware/ckad-demo:bad$version
#done

IMAGES=""
#for image in nuaware/docker-demo nuaware/k8s-demo nuaware/ckad-demo; do
for image in nuaware/k8s-demo; do
   for version in $(seq $VERSIONS); do
       IMAGES+="${image}:${version} "
       IMAGES+="${image}:bad${version} "
   done
done

push_images $IMAGES

exit 0


