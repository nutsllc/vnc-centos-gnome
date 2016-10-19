#!/bin/bash

_install() {
    yum update -y
    yum install -y firefox
}

_install

exit 0
