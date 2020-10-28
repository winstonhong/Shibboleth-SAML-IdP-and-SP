FROM centos:centos7

MAINTAINER winstonhong@inBay Technologies Inc.

LABEL idp.java.version="8.0.272" \
      idp.jetty.version="9.4.33.v20201020" \
      idp.version="3.4.7"

ENV JETTY_HOME=/opt/jetty-home \
    JETTY_BASE=/opt/shib-jetty-base \
    JETTY_MAX_HEAP=2048m \
    JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=12345 \
    JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=abcde \
    PATH=$PATH:$JRE_HOME/bin

ARG java_version=8.0.272
ARG zulu_version=8.50.0.21
ARG java_hash=f35c570b1918eaf072fb1fd82b8e3e60
ARG jetty_version=9.4.33.v20201020
ARG jetty_hash=365e0d8f311ff04339e63bc7463a63a6cabd99e9
ARG idp_version=3.4.7
ARG idp_hash=28B235279EBE6A6644436A42D09A63E7F914E3E2D22330D48A1B8D75B5357ACB
ARG dta_hash=2f547074b06952b94c35631398f36746820a7697

# Sync latest updates and install dependencies
RUN yum -y update \
    && yum -y install wget tar which \
    && yum -y clean all

# Add a user for the Jetty server
RUN useradd jetty -U -s /bin/false

# Download Java, verify the hash, and install
RUN cd / \
    && wget http://cdn.azul.com/zulu/bin/zulu$zulu_version-ca-jdk$java_version-linux_x64.tar.gz \
    && echo "$java_hash  zulu$zulu_version-ca-jdk$java_version-linux_x64.tar.gz" | md5sum -c - \
    && tar -zxvf zulu$zulu_version-ca-jdk$java_version-linux_x64.tar.gz -C /opt \
    && rm zulu$zulu_version-ca-jdk$java_version-linux_x64.tar.gz \
    && ln -s /opt/zulu$zulu_version-ca-jdk$java_version-linux_x64/jre/ /opt/jre-home

# Download Jetty, verify the hash, and install, initialize a new base
RUN cd / \
    && wget https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/$jetty_version/jetty-distribution-$jetty_version.tar.gz \
    && echo "$jetty_hash  jetty-distribution-$jetty_version.tar.gz" | sha1sum -c - \
    && tar -zxvf jetty-distribution-$jetty_version.tar.gz -C /opt \
    && rm jetty-distribution-$jetty_version.tar.gz \
    && ln -s /opt/jetty-distribution-$jetty_version/ /opt/jetty-home

# Config Jetty
RUN cd / \
    && cp /opt/jetty-home/bin/jetty.sh /etc/init.d/jetty \
    && mkdir -p /opt/shib-jetty-base/modules /opt/shib-jetty-base/lib/ext /opt/shib-jetty-base/resources \
    && cd /opt/shib-jetty-base \
    && touch start.ini \
    && /opt/jre-home/bin/java -jar ../jetty-home/start.jar --add-to-startd=http,https,deploy,ext,annotations,jstl

# Download Shibboleth IdP, verify the hash, and install
RUN cd / \
    && wget  https://shibboleth.net/downloads/identity-provider/archive/$idp_version/shibboleth-identity-provider-$idp_version.tar.gz \
    && echo "$idp_hash  shibboleth-identity-provider-$idp_version.tar.gz" | sha256sum -c - \
    && tar -zxvf  shibboleth-identity-provider-$idp_version.tar.gz -C /opt \
    && rm /shibboleth-identity-provider-$idp_version.tar.gz \
    && ln -s /opt/shibboleth-identity-provider-$idp_version/ /opt/shibboleth-idp

# Download the library to allow SOAP Endpoints, verify the hash, and place
# Setting owner ownership and permissions on new items in this command
RUN cd / \
    && wget https://build.shibboleth.net/nexus/content/repositories/releases/net/shibboleth/utilities/jetty9/jetty9-dta-ssl/1.0.0/jetty9-dta-ssl-1.0.0.jar \
    && echo "$dta_hash  jetty9-dta-ssl-1.0.0.jar" | sha1sum -c - \
    && mv jetty9-dta-ssl-1.0.0.jar /opt/shib-jetty-base/lib/ext/ \
    && chown -R root:jetty /opt \
    && chmod -R 640 /opt \
    && chmod 750 /opt/jre-home/bin/java

# Copy everything in the local bin/ folder inside the container /usr/local/bin path
COPY bin/ /usr/local/bin/

# Copy the entire local base/shib-jetty-based folder inside the container to the shibboleth install dir
COPY base/shib-jetty-base/ /opt/shib-jetty-base/

# Copy the entire local base/shibboleth-idp folder inside the container to the shibboleth install dir
COPY base/shibboleth-idp/ /opt/shibboleth-idp/

# Create the logs directory
RUN mkdir /opt/shib-jetty-base/logs

# Setting owner ownership and permissions on new items from the COPY command
RUN chown -R root:jetty /opt/shib-jetty-base \
    && chmod -R 640 /opt/shib-jetty-base \
    && chmod -R 750 /opt/shibboleth-idp/bin \
    && chmod 750 /usr/local/bin/run-jetty.sh \
    && chmod 750 /usr/local/bin/init-idp.sh

# Opening 4443 (browser TLS), 8443 (mutual auth TLS)
EXPOSE 4443 8443

# Run Shibboleth Jetty Server
RUN mkdir $JETTY_BASE/tmp
CMD ["run-jetty.sh"]
