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
CMD ["/bin/bash"]

RUN ulimit -n 65536

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl http://mirrors.163.com/.help/CentOS7-Base-163.repo > /etc/yum.repos.d/CentOS-Base.repo
RUN yum clean all
RUN yum makecache
# Install Ruby
# RUN yum update && yum -y upgrade 
# RUN yum install -y wget gcc make openssl-devel.x86_64 openssl.x86_64
RUN yum install -y wget gcc make openssl-devel.x86_64 openssl.x86_64 openssh-server.x86_64 openssh-server-sysvinit.x86_64 openssh.x86_64
RUN mkdir -p /opt/mops/tmp 
# RUN cd /opt/mops/tmp &&  wget https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz
RUN cd /opt/mops/tmp && \
    wget http://172.17.0.36/ruby-2.2.3.tar.gz && \
    tar zxf ruby-2.2.3.tar.gz && \
    cd ruby-2.2.3 && \
    ./configure --prefix=/opt/mops/ruby && \
    make && make install

# Install fluentd
RUN /opt/mops/ruby/bin/gem sources --add https://ruby.taobao.org/ --remove https://rubygems.org/
RUN /opt/mops/ruby/bin/gem install fluentd --no-ri --no-rdoc
RUN ln -s /opt/mops/ruby/bin/* /usr/local/bin/ && \
    gem install fluent-plugin-s3

# Configure fluentd
RUN mkdir /opt/mops/fluentd && \
    cd /opt/mops/fluentd && \
    fluentd --setup /opt/mops/fluentd/conf
ADD fluent.conf /opt/mops/fluentd/conf/fluent.conf

# Run fluentd
RUN echo "fluentd -c /opt/mops/fluentd/conf/fluent.conf -d /opt/mops/fluentd/fluentd.pid -o /tmp/fluentd.log -p /opt/mops/fluentd/conf/plugin/" >> /root/.bashrc
