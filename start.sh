
/etc/init.d/postgresql start
/etc/init.d/apache2 start
su renderaccount
renderd -f -c /usr/local/etc/renderd.conf 