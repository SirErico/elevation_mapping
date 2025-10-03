#!/bin/bash
IMAGE_NAME="elevation_mapping_test1:latest"

# Define environment variables for enabling graphical output for the container.
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    touch $XAUTH
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
    chmod a+r $XAUTH
fi

#==
# Launch container
#==

# # Create symlinks to user configs within the build context.
# mkdir -p .etc && cd .etc
# ln -sf /etc/passwd .
# ln -sf /etc/shadow .
# ln -sf /etc/group .
# cd ..

# Launch a container from the prebuilt image.
echo "---------------------"
RUN_COMMAND="docker run \
  --volume=$XSOCK:$XSOCK:rw \
  --volume=$XAUTH:$XAUTH:rw \
  --volume=$(pwd)/../../..:/home/ros/workspace \
  --env="QT_X11_NO_MITSHM=1" \
  --env="XAUTHORITY=$XAUTH" \
  --env="DISPLAY=$DISPLAY" \
  --privileged \
  --net=host \
  --gpus all \
  -it $IMAGE_NAME"
echo -e "[run.sh]: \e[1;32mThe final run command is\n\e[0;35m$RUN_COMMAND\e[0m."
$RUN_COMMAND
echo -e "[run.sh]: \e[1;32mDocker terminal closed.\e[0m"
#   --entrypoint=$ENTRYPOINT \