
/etc/init.d/postgresql start
/etc/init.d/apache2 start
runuser -l renderaccount -c "renderd -f -c /usr/local/etc/renderd.conf" 
