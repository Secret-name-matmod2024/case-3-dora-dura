#!/bin/bash
set -e
set -u

export DISPLAY=$DISPLAY
echo "setting display to $DISPLAY"
xhost +
docker run -it -v .:/workspace:z -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY --network=host --gpus=all --name=isaacgym_container isaacgym /bin/bash
xhost -
