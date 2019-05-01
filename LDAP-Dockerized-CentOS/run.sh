#!/bin/bash
docker run --rm -d -p 389:389 --name openldap example/openldap:latest
