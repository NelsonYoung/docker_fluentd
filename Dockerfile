FROM scratch
MAINTAINER The Fluentd based on CentOS Project <mops@mokylin.com>
ADD fluentd_docker.tar.xz /
LABEL Vendor="CentOS"
LABEL License=GPLv2

# Volumes for systemd
# VOLUME ["/run", "/tmp"]

# Environment for systemd
# ENV container=docker

# For systemd usage this changes to /usr/sbin/init
# Keeping it as /bin/bash for compatability with previous
#CMD ["/bin/bash"]

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV HOME /root

RUN ulimit -n 65536

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl http://mirrors.163.com/.help/CentOS7-Base-163.repo > /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all
RUN yum makecache
# Install Ruby
# RUN yum update && yum -y upgrade 
RUN yum install -y wget gcc make openssl-devel.x86_64 openssl.x86_64
RUN mkdir -p /opt/mops/tmp 
RUN (cd /opt/mops/tmp &&  wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz)
RUN (cd /opt/mops/tmp && tar zxf ruby-2.2.3.tar.gz && cd ruby-2.2.3 && ./configure --prefix=/opt/mops/ruby && make && make install)

# Install fluentd
RUN /opt/mops/ruby/bin/gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
RUN /opt/mops/ruby/bin/gem install fluentd --no-ri --no-rdoc
RUN ln -s /opt/mops/ruby/bin/* /usr/local/bin/

# Configure fluentd
RUN (mkdir /opt/mops/fluentd && cd /opt/mops/fluentd && fluentd --setup /opt/mops/fluentd/conf)

# Use supervisor to monitor fluentd
RUN (cd /opt/mops/tmp && wget https://pypi.python.org/packages/source/s/setuptools/setuptools-19.1.1.tar.gz#md5=792297b8918afa9faf826cb5ec4a447a)
RUN (cd /opt/mops/tmp && tar zxvf setuptools-19.1.1.tar.gz && cd /opt/mops/tmp/setuptools-19.1.1 && python setup.py build && python setup.py install)
RUN easy_install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d
#RUN echo_supervisord_conf > /etc/supervisord.conf
ADD supervisord.conf /etc/supervisord.conf

# Run fluentd
ADD fluentd.sv.conf /etc/supervisor/conf.d/

#RUN echo "[program:fluentd]" >> /etc/supervisord.conf
#RUN echo "command=/opt/mops/ruby/bin/fluentd -c /opt/mops/fluentd/conf/fluent.conf  -vvv" >> /etc/supervisord.conf
#RUN echo "autostart=true " >> /etc/supervisord.conf
#RUN echo "autorestart=true" >> /etc/supervisord.conf
#RUN echo "startsecs=3 " >> /etc/supervisord.conf
#RUN echo "stderr_logfile=/tmp/fluentd_err.log" >> /etc/supervisord.conf
#RUN echo "stdout_logfile=/tmp/fluentd.log" >> /etc/supervisord.conf
#RUN echo "redirect_stderr=true" >> /etc/supervisord.conf
#RUN echo "environment=PATH=\"/opt/mops/ruby/bin\"" >> /etc/supervisord.conf
#RUN echo "environment=PATH=\"/usr/bin\"" >> /etc/supervisord.conf

# Remove tmp files
RUN rm -rf /opt/mops/tmp

# RUN supervisord -c /etc/supervisord.conf
#RUN echo "/usr/bin/supervisord -c /etc/supervisord.conf" >> /root/.bashrc
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
# CMD ["/bin/echo", "/etc/supervisord.conf"]
#ENTRYPOINT ["/bin/echo"]
#ENTRYPOINT ["/usr/bin/supervisord", "-c"]
#ENTRYPOINT ["top", "-b"]
#CMD ["-c"]
#ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
#RUN (echo "#!/bin/bash" >> /opt/run.sh && echo "nohup /usr/bin/supervisord -c /etc/supervisord.conf &" >> /opt/run.sh && echo "sleep 1" >> /opt/run.sh && chmod 777 /opt/run.sh)
#COPY run.sh /opt/run.sh
#ENTRYPOINT [“/opt/run.sh”]
#RUN /bin/bash /opt/run.sh
#CMD ["/bin/bash", "/opt/run.sh"]
#CMD ["/usr/bin/which supervisord"]
#CMD ["/etc/supervisord.conf"]
#ENTRYPOINT ["/opt/run.sh"]
#CMD /opt/run.sh console

# default command
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
