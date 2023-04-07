# Shibboleth-SAML-IdP-and-SP

--------------------

The SAML IdP (Identity Provider) and SAML SP (Service Provider) are built based on open-source Shibboleth source repository. 

Installation
------------
+ Download the source repository from GitHub.
```
git clone https://github.com/winstonhong/Shibboleth-SAML-IdP-and-SP
``` 
+ Build and Run OpenLDAP server over Docker Container.
```
cd Shibboleth-SAML-IdP-and-SP/LDAP-Dockerized-CentOS
./build.sh
./run.sh
cd -
```
+ Build and Run Shibboleth SAML IdP server over Docker Container.
```
cd Shibboleth-SAML-IdP-and-SP/shibboleth-idp-dockerized
./build.sh
./run.sh
cd -
```
+ Build and Run Shibboleth SAML SP server over Docker Container.
```
cd Shibboleth-SAML-IdP-and-SP/shibboleth-sp-testapp
./build.sh
./run.sh
cd -
```
+ In addition to running three (3) servers using separate scripts as described above, we can Run OpenLDAP server, Shibboleth SAML IdP server and SP server using docker compose.
```
cd Shibboleth-SAML-IdP-and-SP/LDAP-Dockerized-CentOS
./build.sh
cd -
cd Shibboleth-SAML-IdP-and-SP/shibboleth-idp-dockerized
./build.sh
cd -
cd Shibboleth-SAML-IdP-and-SP/shibboleth-sp-testapp
./build.sh
cd -
docker-compose up
```

Shibboleth SAML IdP and SAML SP Demo
------------
+ Access the link "https://sp.example.org:2443" to launch the Shibboleth SAML SP demo
+ Click **Login**
+ You are redirected to Shibboleth SAML IdP 
+ Input Username/Password credential (e.g., winstonhong/winston-passwd) and then Click **Login**
+ You are redirected back to reach Shibboleth SAML SP-protected web page

References
-------
SHIBBOLETH CONSORTIUM: Privacy Preserving Identity Management

https://www.shibboleth.net/ 


Shibboleth Identity Provider (IdP) base-image

https://github.com/Unicon/shibboleth-idp-dockerized


Shibboleth Service Provider (SP) base-image

https://github.com/Unicon/shibboleth-sp-dockerized


Support
-------
Shibboleth SAML identity provider and SAML service provider demo are created by 

[winstonhong](https://github.com/winstonhong) @ [inbaytech](https://github.com/inbaytech)
