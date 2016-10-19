#!/bin/bash
set -e

_install() {
    printf "install $1..."
    yum update -y \
    && yum install -y gthumb \
    && echo "done."
}

_install

exit 0
