#!/bin/bash
set -e

_install() {
    printf "install $1..."
    yum update -y \
    && yum install -y \
        file-roller \
        unzip \
    && echo "done."
}

_install

exit 0
