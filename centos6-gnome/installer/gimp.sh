#!/bin/bash

_install() {
    yum update -y
    yum install -y gimp
}

_install

exit 0
