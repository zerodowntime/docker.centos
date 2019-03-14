##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##

ARG CENTOS_VERSION=latest
ARG CONFD_VERSION=v0.16.0

##############################################################################
## confd builder

FROM golang:1 as confd-builder

ARG CONFD_VERSION

RUN go get github.com/kelseyhightower/confd && \
    cd /go/src/github.com/kelseyhightower/confd && \
    git checkout $CONFD_VERSION && \
    make

##############################################################################
## su-exec builder

FROM gcc:8 as su-exec-builder

RUN git clone https://github.com/ncopa/su-exec.git && \
    cd su-exec && \
    make

##############################################################################
## main image

FROM centos:$CENTOS_VERSION

# confd
COPY --from=confd-builder /go/src/github.com/kelseyhightower/confd/bin/confd /usr/local/bin/confd
COPY confd /etc/confd

# su-exec
COPY --from=su-exec-builder /su-exec/su-exec /usr/local/bin/su-exec
