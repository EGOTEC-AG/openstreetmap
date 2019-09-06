FROM ubuntu:18.04
MAINTAINER Heiko Roth, EGOTEC GmbH <roth@egotec.com>
# https://switch2osm.org/manually-building-a-tile-server-18-04-lts/

RUN apt-get update
RUN apt-get -y install libboost-all-dev git-core tar unzip wget bzip2 build-essential autoconf libtool libxml2-dev libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev munin-node munin libprotobuf-c0-dev protobuf-c-compiler libfreetype6-dev libtiff5-dev libicu-dev libgdal-dev libcairo-dev libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont lua5.1 liblua5.1-dev libgeotiff-epsg curl

RUN ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime && export DEBIAN_FORNTEND=noninteractive
RUN apt-get -y install postgresql postgresql-contrib postgis postgresql-10-postgis-2.4 postgresql-10-postgis-scripts

#USER postgres
#RUN /etc/init.d/postgresql start && \ 
#	createuser renderaccount && \
#        createdb -E UTF8 -O renderaccount gis && \
#	echo "\c gis" | psql && \
#	echo "CREATE EXTENSION postgis;" | psql && \
#	echo "CREATE EXTENSION hstore;" | psql && \
#	echo "ALTER TABLE geometry_columns OWNER TO renderaccount;" | psql && \ 
#	echo "ALTER TABLE spatial_ref_sys OWNER TO renderaccount;" | psql && \
#	/etc/init.d/postgresql stop

USER root
RUN useradd -m renderaccount

# Installing osm2pgsql

RUN apt-get -y install make cmake g++ libboost-dev libboost-system-dev libboost-filesystem-dev libexpat1-dev zlib1g-dev libbz2-dev libpq-dev libgeos-dev libgeos++-dev libproj-dev lua5.2 liblua5.2-dev
RUN mkdir ~/src && \
	cd ~/src && \
	git clone git://github.com/openstreetmap/osm2pgsql.git
RUN cd ~/src/osm2pgsql && mkdir build && cd build && cmake ..
RUN cd ~/src/osm2pgsql/build && make
RUN cd ~/src/osm2pgsql/build && make install

# Mapnik

RUN apt-get -y install autoconf apache2-dev libtool libxml2-dev libbz2-dev libgeos-dev libgeos++-dev libproj-dev gdal-bin libmapnik-dev mapnik-utils python-mapnik
RUN cd ~/src && git clone -b switch2osm git://github.com/SomeoneElseOSM/mod_tile.git
RUN cd ~/src/mod_tile && ./autogen.sh
RUN cd ~/src/mod_tile && ./configure && make && make install
RUN cd ~/src/mod_tile && make install-mod_tile
RUN ldconfig

# Stylesheet configuration

RUN apt-get -y install npm nodejs
RUN npm install -g carto
RUN cd /var/lib/postgresql/ && mkdir src && cd src && git clone git://github.com/gravitystorm/openstreetmap-carto.git
RUN cd /var/lib/postgresql/src/openstreetmap-carto && carto project.mml > mapnik.xml

# Loading data

RUN mkdir /tmp/data && cd /tmp/data && wget http://download.geofabrik.de/asia/azerbaijan-latest.osm.pbf

COPY init.sql /tmp/init.sql
USER postgres
RUN /etc/init.d/postgresql start && \ 
	createuser renderaccount && \
        createdb -E UTF8 -O renderaccount gis && \
	cat /tmp/init.sql | psql && \
	echo "\dx" | psql && \
	echo "SHOW search_path" | psql && \
	osm2pgsql -d gis --create --slim -G --hstore --tag-transform-script ~/src/openstreetmap-carto/openstreetmap-carto.lua -C 2500 --number-processes 8 -S ~/src/openstreetmap-carto/openstreetmap-carto.style /tmp/data/azerbaijan-latest.osm.pbf && \
	etc/init.d/postgresql stop

USER root

# Fonts
RUN apt-get -y install fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted ttf-unifont

# Shapefile download
RUN cd /var/lib/postgresql/src/openstreetmap-carto && scripts/get-shapefiles.py

# Setting up your webserver

# Configuring Apache

RUN mkdir /var/lib/mod_tile && \
	chown renderaccount /var/lib/mod_tile && \
	mkdir /var/run/renderd && \
	chown renderaccount /var/run/renderd

RUN echo "LoadModule tile_module /usr/lib/apache2/modules/mod_tile.so" > /etc/apache2/conf-available/mod_tile.conf && \
	a2enconf mod_tile
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN ln -s /var/lib/postgresql/src /home/renderaccount/src
