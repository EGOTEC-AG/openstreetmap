# create image

## update ubuntu image

````
cd ~/workspace/egocms/dev/docker/egotec-ubuntu-18.04
docker pull ubuntu:18.04
````

## build image

````
docker build -t egotec/ubuntu:18.04 .
````

## push to hub.docker.com

````
docker push egotec/ubuntu:18.04
````

Jetzt ist die aktuelle Version online. Alle anderen Punkte sind optional.

# clean rebuild

Einen clean build macht man, wenn man sicher gehen möchte, das alles neu erzeugt wird.
Normalerweise merkt docker automatisch, ob sich im Dockerfile etwas geändert hat.

Use flag `--no-cache=true`

````
cd ~/workspace/egocms/dev/docker/egotec-egocms
docker build --no-cache=true -t egotec/ubuntu:18.04 .
````
