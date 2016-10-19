#!/bin/bash
set -e

_install() {
    printf "install $1..."
    yum update -y \
    && yum install -y \
        samba-client \
        samba-common \
    && echo "done."
}

_install

exit 0
