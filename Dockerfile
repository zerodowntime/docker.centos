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

RUN mkdir -p /etc/confd/{conf.d,templates}
COPY --from=confd-builder /go/src/github.com/kelseyhightower/confd/bin/confd /usr/local/bin/confd
COPY confd/confd.toml /etc/confd/confd.toml
COPY confd/templates  /etc/confd/templates
COPY confd/conf.d     /etc/confd/conf.d

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh"]
