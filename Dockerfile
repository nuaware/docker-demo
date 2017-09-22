
# build stage
FROM golang:alpine AS build-env

ADD . /src
RUN cd /src && go build -o docker-demo

# final stage
FROM alpine

WORKDIR /app
COPY    --from=build-env /src/docker-demo /app/

#ENTRYPOINT ./docker-demo


#FROM scratch


#ADD docker-demo /bin/docker-demo
ADD static /app/static
ADD templates /app/templates
EXPOSE 8080
ENTRYPOINT ["/app/docker-demo"]
CMD ["-listen=:8080"]
