#!/bin/sh
mkdir config
echo $NGINX_USER:$NGINX_PASSWORD > config/htpasswd
