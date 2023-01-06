#!/bin/bash

PACKAGES="cloudflare-warp-bin"
sh ./scripts/query_install.sh yay $PACKAGES

sudo systemctl enable warp-svc.service
sudo systemctl start warp-svc.service

warp-cli register
warp-cli connect

warp-cli set-mode warp+doh

curl ipinfo.io/geo
curl https://www.cloudflare.com/cdn-cgi/trace/

warp-cli disconnect
warp-cli status

curl ipinfo.io/geo
curl https://www.cloudflare.com/cdn-cgi/trace/
