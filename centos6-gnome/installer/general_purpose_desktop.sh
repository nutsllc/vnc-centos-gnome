#!/bin/bash
set -e

_install() {
    printf "install $1..."
    yum update -y \
    && yum groupinstall -y "General Purpose Desktop" \
    && echo "done."
}

_install

exit 0
