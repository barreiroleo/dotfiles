#!/bin/bash

# If not package manager or packages received, abort
if [[ -z $1 ]]; then exit; fi

# If only the packages are received, use pacman
if [[ -z $2 ]]; then
    PACK_MAN=pacman; PACKAGES=$1
else
    PACK_MAN=$1; PACKAGES=$2
fi

# Check the selected package manager. Defaults exit.
case "$PACK_MAN" in
    pacman) PACK_MAN="sudo pacman"
    ;;
    yay) PACK_MAN=yay
    ;;
    *) exit
    ;;
esac

echo $PACK_MAN $PACKAGES
! pacman --query $PACKAGES && $PACK_MAN -S $PACKAGES --noconfirm; true
