#!/bin/bash
set -e

_install() {
    printf "install $1..."
    yum update -y \
    && yum install -y \
        htop \
        dstat \
        gnokme-utils \
        gnome-system-monitor \
        system-config-language \
        gconf-editor \
    && echo "done."
}

_install

exit 0
