# docker_fluentd
Usage

Download the Dockerfile and fluentd_docker.tar.xz in the files folder.


Step 1: Run the command below to build docker images.
> docker build --tag="mops/fluentd:v2" --file=Dockerfile .

Step 2: Startup the docker
> docker run -t -i --name=test_fluent mops/fluentd:v2 "/bin/bash" -P -d

Step 3: Attach the running container and startup supervisor. 
> supervisord -c /etc/supervisord.conf

Step 4: Check the fluentd state.
> supervisorctl status
