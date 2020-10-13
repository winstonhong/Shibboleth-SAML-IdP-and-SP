#!/bin/bash
docker run --rm \
           -it \
           -d \
           -v $(pwd)/ext-conf:/opt/shibboleth-idp-ext-conf \
           -e JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=12345 \
           -e JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=abcde \
           -p 443:4443 \
           -p 8443:8443 \
	   -p 80:8080   \
           --link openldap:openldap \
	   --name="shibboleth-idp" \
           example/shibboleth-idp:latest $@
