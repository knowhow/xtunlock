#!/bin/bash

PKG_NAME=xtunlock
PKG_DIR=xtunlock

mkdir package
rm package/$PK_NAME.gz
gnutar cvfz package/$PKG_NAME.gz ../$PKG_DIR --exclude=.gitignore --exclude=package --exclude=*.gz --exclude=.git

