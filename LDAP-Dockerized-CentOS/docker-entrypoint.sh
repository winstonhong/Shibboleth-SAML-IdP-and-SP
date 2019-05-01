#!/bin/bash

ulimit -n 8192

set -e

if [ ! -d "/var/lib/dirsrv/slapd-dir/db/userRoot" ]
then
	sed -i '/if (@errs = startServer($inf))/,/}/d' /usr/lib64/dirsrv/perl/*;
	setup-ds.pl --silent --file /ds-setup.inf;
	/usr/sbin/ns-slapd -D /etc/dirsrv/slapd-dir;
	sleep 10;
	ldapadd -H ldap:/// -f /users.ldif -x -D "cn=Directory Manager" -w ldap-passwd;
fi

chown -R ldapadmin:ldapadmin /var/lib/dirsrv

exec "$@"

