# docker_fluentd
Usage
Step 1: Run the command below to build docker images.
> docker build --tag="mops/fluentd:v2" --file=Dockerfile .

Step 2: Startup the docker
> docker run -t -i mops/fluentd:v2 "/bin/bash"

Step 3: Startup supervisor. 
> supervisord -c /etc/supervisord.conf

Step 4: Check the fluentd state.
> supervisorctl status
