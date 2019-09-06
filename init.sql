\c gis
CREATE EXTENSION postgis ;
CREATE EXTENSION hstore ;
ALTER TABLE geometry_columns OWNER TO renderaccount ;
ALTER TABLE spatial_ref_sys OWNER TO renderaccount ;
ALTER TABLE planet_osm_polygon OWNER TO renderaccount ;
ALTER TABLE planet_osm_line OWNER TO renderaccount ;
ALTER TABLE planet_osm_point OWNER TO renderaccount ;
ALTER TABLE planet_osm_roads OWNER TO renderaccount ;

