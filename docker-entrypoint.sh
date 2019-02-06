#!/bin/bash

##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##

confd -onetime || exit 2

cat /tmp/myconfig.conf

exec "$@"
