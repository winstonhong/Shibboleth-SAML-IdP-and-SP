# Dockerized OpenLDAP

## Building Docker Image for OpenLDAP

```
docker build --tag="example/openldap:latest" .
```

## Running OpenLDAP on Docker Container

* Start Docker container for OpenLDAP 

```
$docker run -d -p 389:389 --name openldap example/openldap:latest
```

* Verify whether OpenLDAP server runs well

You should see a list of OpenLDAP users.

```
$docker exec openldap ldapsearch -x -H ldap://localhost -b "dc=example,dc=com" -D "cn=admin,dc=example,dc=com" -w ldap-passwd
```
