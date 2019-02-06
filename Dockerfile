##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##

FROM golang:1.10 as confd-builder

ARG CONFD_VERSION=v0.16.0

RUN go get github.com/kelseyhightower/confd && \
    cd /go/src/github.com/kelseyhightower/confd && \
    git checkout $CONFD_VERSION && \
    make


FROM centos:7

RUN mkdir -p /etc/confd/{conf.d,templates}
COPY --from=confd-builder /go/src/github.com/kelseyhightower/confd/bin/confd /usr/local/bin/confd
COPY confd/confd.toml /etc/confd/confd.toml
COPY confd/templates  /etc/confd/templates
COPY confd/conf.d     /etc/confd/conf.d

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh"]
