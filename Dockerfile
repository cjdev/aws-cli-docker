FROM alpine:3.4

RUN apk --no-cache update && \
    apk --no-cache add bash && \
    apk --no-cache add python py-pip py-setuptools ca-certificates groff less && \
    pip --no-cache-dir install awscli && \
    rm -rf /var/cache/apk/*

COPY kick-ecs-service.sh /usr/local/bin/kick-ecs-service.sh

WORKDIR /data
