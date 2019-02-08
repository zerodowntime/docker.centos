##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##

ARG CENTOS_VERSION=latest
ARG CONFD_VERSION=v0.16.0

FROM golang:1.10 as confd-builder

ARG CONFD_VERSION

RUN go get github.com/kelseyhightower/confd && \
    cd /go/src/github.com/kelseyhightower/confd && \
    git checkout $CONFD_VERSION && \
    make


FROM centos:$CENTOS_VERSION

COPY --from=confd-builder /go/src/github.com/kelseyhightower/confd/bin/confd /usr/local/bin/confd
COPY confd /etc/confd

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh"]
