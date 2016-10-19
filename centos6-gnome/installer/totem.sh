#!/bin/bash

_install() {
    yum update -y
    yum install -y totem
}

_install

exit 0
