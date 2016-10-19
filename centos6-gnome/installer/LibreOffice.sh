#!/bin/bash

_install() {
    yum update -y
    yum install -y libreoffice libreoffice-langpack-ja
}

_install

exit 0
