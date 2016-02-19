# Docker fluentd
###Scenario:

Read apache logs and upload to aws s3.
Apache httpd application run on physics machine and log path is /var/log/httpd/.
Fluentd pos_file should also on physics, we set diretory is /var/log/tmp/

Usage:

Download the Dockerfile and fluentd_docker.tar.xz.

### Docker container with supervisord

Step 1: Run the command below to build docker images.
> docker build --tag="mops/fluentd:v2" --file=Dockerfile .

Step 2: Startup the docker
> docker run -v /var/log/httpd/:/var/log/httpd/ -v /var/log/tmp/:/var/log/tmp -t -i --name=test_fluent --restart=always -d -P mops/fluentd:v2

Step 3: Attach the running container and check the fluentd state.
> supervisorctl status

### Docker container without supervisord
Step 1: Run the command below to build docker images.
> docker build --tag="mops/fluentd:v3" --file=Dockerfile_without_supervisord .

Step 2: Startup the docker
> docker run -v /var/log/httpd/:/var/log/httpd/ -v /var/log/tmp/:/var/log/tmp -t -i --name=test_fluent --restart=always -d -P mops/fluentd:v3 "/bin/bash"

Step 3: Attach the running container and check the fluentd state.
> ps aux | grep fluentd

### Notice
Supervisord should run on no deamon status. Otherwise container will exit when run it.
