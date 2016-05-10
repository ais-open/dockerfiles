#!/usr/bin/env bash

# determine whether the Dockerfile is under a folder with the tag name
FILE=./$IMAGE
if [ -f ./$IMAGE/$TAG/Dockerfile ]; then
	FILE=./$IMAGE/$TAG
fi

echo Processing build for $REG_IMG_TAG...
# build and push the docker image
docker build -t $REGISTRY/$IMAGE:$TAG $FILE && docker push $REGISTRY/$IMAGE:$TAG

# indicate failure
if [ $? -ne 0 ]; then
	echo Error building and pushing $IMAGE:$TAG image!
	exit 1
fi

# indicate success
echo Image $IMAGE:$TAG built and pushed successfully!
