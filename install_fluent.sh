#!/bin/bash

resource=10.96.29.44:8081
mkdir -p /opt/mops/fluent/conf
mkdir -p /opt/mops/tmp
mkdir /var/log/fluent_pos
cd /opt/mops/tmp

wget http://${resource}/ruby.tar.xz
wget http://${resource}/generate_fluent_conf.sh

xz -d ruby.tar.xz 
tar xf ruby.tar
mv ruby /opt/mops/
ln -s /opt/mops/ruby/bin/* /usr/local/bin
fluentd --setup /opt/mops/fluent/conf
sh generate_fluent_conf.sh
mv fluent.conf /opt/mops/fluent/conf
cd ~
rm -rf /opt/mops/tmp
chmod 777 /var/run/screen






wget http://10.96.29.44:8081/install_fluent.sh
sh install_fluent.sh
rm install_fluent.sh
screen -S fluent

fluentd -c /opt/mops/fluent/conf/fluent.conf
