#!/bin/bash

PACKAGES="texlive-bin latexmk biber tectonic \
    texlive-{bibtexextra,core,fontsextra,formatsextra,latexextra} \
    texlive-{pictures,pstricks,publishers,science} \
    texlive-{games,humanities,music}"

sh ./scripts/query_install.sh pacman $PACKAGES
