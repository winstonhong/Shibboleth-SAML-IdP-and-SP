#!/bin/bash
docker run -it -v $(pwd):/ext-mount --rm example/shibboleth-idp:latest init-idp.sh

# Do not use the ones that the init script generates
rm ext-conf/conf/attribute-filter.xml
rm ext-conf/conf/saml-nameid.xml
