#!/bin/bash

push_images() {
    echo; echo "Docker login:"
    docker login

    for image in $*; do
        echo; echo "push $image"
        docker push $image
    done
}


echo; echo "push build:21"


sed "s/REPLACE_LOGO/docker_blue.txt/" demo-main-go.tmpl > main.go
sed "s/REPLACE_LOGO/docker_blue.png/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl
docker build -t mjbright/docker-demo:1 .
docker tag      mjbright/docker-demo:1 mjbright/docker-demo:20
#exit 1


sed "s/REPLACE_LOGO/docker_red.txt/" demo-main-go.tmpl > main.go
sed "s/REPLACE_LOGO/docker_red.png/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl
docker build -t mjbright/docker-demo:2 .
docker tag      mjbright/docker-demo:2 mjbright/docker-demo:21

sed "s/REPLACE_LOGO/kubernetes_blue.txt/" demo-main-go.tmpl > main.go
sed "s/REPLACE_LOGO/kubernetes_blue.png/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl
docker build -t mjbright/k8s-demo:1 .
docker tag      mjbright/k8s-demo:1 mjbright/k8s-demo:20

sed "s/REPLACE_LOGO/kubernetes_red.txt/" demo-main-go.tmpl > main.go
sed "s/REPLACE_LOGO/kubernetes_red.png/" templates/index.html.tmpl.tmpl > templates/index.html.tmpl
docker build -t mjbright/k8s-demo:2 .
docker tag      mjbright/k8s-demo:2 mjbright/k8s-demo:21

#push_images mjbright/docker-demo:1 mjbright/docker-demo:2 mjbright/k8s-demo:1 mjbright/k8s-demo:2

exit 0


