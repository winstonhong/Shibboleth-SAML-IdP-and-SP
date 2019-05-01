#!/bin/bash
docker run -it --rm -p 2080:80 -p 2443:443 --name="shibboleth-sp" example/shibboleth-sp:latest
