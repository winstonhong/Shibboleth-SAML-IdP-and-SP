#!/bin/bash

set -x
openssl genrsa -aes128 -out ext-conf/credentials/jetty.key
openssl req -new -x509 -newkey rsa:2048 -sha256 -key ext-conf/credentials/jetty.key -out ext-conf/credentials/jetty.crt
openssl pkcs12 -inkey ext-conf/credentials/jetty.key -in ext-conf/credentials/jetty.crt -export -out ext-conf/credentials/idp-browser.p12
