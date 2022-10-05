#!/bin/bash

sh ./scripts/query_install.sh yay appimagelauncher

DIR=/opt/appimages
if [[ ! -d "$DIR" ]]; then
    sudo mkdir /opt/appimages/
fi

sudo chown leonardo:leonardo -R $DIR
