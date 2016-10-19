#!/bin/bash

_install() {
    yum update -y
    yum install -y evolution
}

_install

exit 0
