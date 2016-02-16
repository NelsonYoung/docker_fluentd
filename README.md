# docker_fluentd
Usage

Download the Dockerfile and fluentd_docker.tar.xz.

## Docker container with supervisord

Step 1: Run the command below to build docker images.
> docker build --tag="mops/fluentd:v2" --file=Dockerfile .

Step 2: Startup the docker
> docker run -t -i --name=test_fluent -d -P mops/fluentd:v2 "/bin/bash"

Step 3: Attach the running container and check the fluentd state.
> supervisorctl status

## Docker container without supervisord
Step 1: Run the command below to build docker images.
> docker build --tag="mops/fluentd:v2" --file=Dockerfile_without_supervisord .

Step 2: Startup the docker
> docker run -t -i --name=test_fluent -d -P mops/fluentd:v2 "/bin/bash"

Step 3: Attach the running container and check the fluentd state.
> supervisorctl status
