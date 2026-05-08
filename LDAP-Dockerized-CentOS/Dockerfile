FROM centos:centos7

MAINTAINER John Gasper <jgasper@unicon.net>

# CentOS 7 / EPEL 7 are EOL; mirrorlist.centos.org and EPEL metalink no longer work.
# Point yum at vault.centos.org and the Fedora Project EPEL archive before installing packages.
RUN sed -i \
        -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' \
        /etc/yum.repos.d/CentOS-*.repo \
    && yum install -y epel-release \
    && sed -i -E \
        -e 's|^metalink=|#metalink=|g' \
        -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=https?://download\.fedoraproject\.org/pub/epel|baseurl=https://archives.fedoraproject.org/pub/archive/epel|g' \
        /etc/yum.repos.d/epel*.repo \
    && yum update -y \
    && yum install -y 389-ds-base 389-adminutil \
    && yum clean all

COPY ds-setup.inf /ds-setup.inf
COPY users.ldif /users.ldif

# The 389-ds setup will fail because the hostname can't reliable be determined, so we'll bypass it and then install.
RUN useradd ldapadmin \
    && rm -fr /var/lock /usr/lib/systemd/system \
    # The 389-ds setup will fail because the hostname can't reliable be determined, so we'll bypass it and then install. \
    && sed -i 's/checkHostname {/checkHostname {\nreturn();/g' /usr/lib64/dirsrv/perl/DSUtil.pm \
    # Not doing SELinux \
    && sed -i 's/updateSelinuxPolicy($inf);//g' /usr/lib64/dirsrv/perl/* \
    # Do not restart at the end \
    && sed -i '/if (@errs = startServer($inf))/,/}/d' /usr/lib64/dirsrv/perl/* \
    && setup-ds.pl --silent --file /ds-setup.inf \
    && /usr/sbin/ns-slapd -D /etc/dirsrv/slapd-dir \
    && sleep 10 \
    && ldapadd -H ldap:/// -f /users.ldif -x -D "cn=Directory Manager" -w ldap-passwd

EXPOSE 389

CMD /usr/sbin/ns-slapd -D /etc/dirsrv/slapd-dir && tail -F /var/log/dirsrv/slapd-dir/access
