# Applied Information Sciences Dockerfiles

This repository contains a reference of base images for use by AIS developers. The steps to build and use these images are outlined below.

## Build

All images should be built with appropriate tags. Fully qualified domain names should also be used to identify the Docker Registry being used to ensure successful pull operations from remote networks. To create a 2.7 tagged Python base image the following command should be used (note trailing period):

```
sudo docker build -t appliedis/python:2.7 .
```

## Test

Once an image is built, it should be tested prior to publishing it to the registry. This can be done using the docker run command. If the Dockerfile contains a CMD statement, verify that the executable defined there is launched. If there is no CMD statement a trailing command can be given to prevent an immediate, silent container shutdown on run. The following two commands demonstrate testing a default CMD, as well as an override.

```
sudo docker run -it appliedis/python:2.7
sudo docker run -it appliedis/python:2.7 echo "Docker CMD override successful"
```

## Tagging

It is worth noting that you can use a more convenient name for testing and then tag the image to the appropriate hostname prior to a push. See docker tag --help for more details on this.

Consistency is key - all directories should track with the image names. All images should be named use lower case letters and dashes, version tags should be set for most specific version we care about. For example, if we wanted to pin to Python 2.7, but wanted flexibility to update to the newest patch release 2.7.10, etc., we would tag as "python:2.7". If we didn't care about the minor version we could just tag as "python:2". We recommend avoiding the use of the latest tag and always specifying an explicit version tag. Docker defaults to use of latest in all cases where a tag is omitted, which can be problematic when it is desirable to pin to specific release versions.

## Publish / "push"

The only way to publish to a remote registry, other than the official Docker Hub, is to use the hostname of your registry as the first portion of the image name. In our case that hostname is *appliedis*. Since we have already tagged our image during the docker build step, we can just issue the push command against the existing image name.

```
sudo docker push appliedis/python:2.7
```

## Usage

Once an image is pushed to the Docker Registry it can be used from any machine with registry connectivity. You can use the image directly as described in the Test section or extend / override it within a Dockerfile:

```
FROM appliedis/python:2.7

... your Dockerfile configuration
CMD ["python", "my-python-script.py"]
```
