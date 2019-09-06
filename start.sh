
/etc/init.d/postgresql startrenderd -f -c /usr/local/etc/renderd.conf
/etc/init.d/apache2 start
echo /tmp/alter.sql > psqls