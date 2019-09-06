# howto run
docker run -p 80:80 -it egotec/openstreetmap bash

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

Jetzt ist die aktuelle Version online. Alle anderen Punkte sind optional.

# clean rebuild

Einen clean build macht man, wenn man sicher gehen möchte, das alles neu erzeugt wird.
Normalerweise merkt docker automatisch, ob sich im Dockerfile etwas geändert hat.

Use flag `--no-cache=true`
