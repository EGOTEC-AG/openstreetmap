# howto run

Run renderd.

````
docker run -p 80:80 -d egotec/openstreetmap bash /start.sh
````

Run bash.

````
docker run -p 80:80 -it egotec/openstreetmap bash
````

# create image

## update ubuntu image

````
docker pull ubuntu:18.04
````

## build image

````
docker build -t egotec/openstreetmap .
````

## push to hub.docker.com

````
docker push egotec/openstreetmap
````

# example links

## Germany

- https://maps.egotec.com/hot/4/8/5.png
- https://maps.egotec.com/hot/5/16/10.png
- https://maps.egotec.com/hot/5/17/10.png
- https://maps.egotec.com/hot/6/33/21.png
- https://maps.egotec.com/hot/7/67/43.png
- https://maps.egotec.com/hot/8/134/87.png

# literatur

- https://switch2osm.org/manually-building-a-tile-server-18-04-lts/
