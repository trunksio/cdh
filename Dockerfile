# VERSION       Java 8


FROM centos
MAINTAINER Lewis Crawford, lewis@thedatashed.co.uk 

ENV JAVA_VERSION 8u92
ENV BUILD_VERSION b14

# Upgrading system
RUN yum -y upgrade
RUN yum -y install wget epel-release
RUN yum -y install gcc gcc-c++ python34 python34-devel  
#RUN yum -y install gcc gcc-c++ python34 python34-devel mysql-devel python-lxml numpy 
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.4
ADD requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt
# Downloading Java
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm

RUN yum -y install /tmp/jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV JAVA_HOME /usr/java/latest

ADD cloudera-manager.repo /etc/yum.repos.d/ 

RUN  yum -y install cloudera-manager-agent cloudera-manager-server-db-2 --skip-broken
###Hack to remove limits for cloudera-scm user
RUN rm /etc/security/limits.d/cloudera-scm.conf
ADD config.ini /etc/cloudera-scm-agent/config.ini
ADD cmstart.sh /cmstart.sh
ADD agentstart.sh /agentstart.sh
expose 10000 10020 10033 1004 1006 10101 11000 11001 11060 111 11443 12000 12001 13562 14000 14001 16000 16001 18080 18081 18088 19888 19890 2049 20550 2181 2888 3181 3888 41414 4181 4242 4867 50010 50020 50030 50060 50070 50075 50090 50111 50470 50475 50495 51000 5678 60000 60010 60020 60030 7077 7078 7180 7182 7183 7184 7185 7186 7187 7432 8005 8018 8019 8020 8021 8022 8023 8030 8031 8032 8033 8038 8040 8041 8042 8044 8080 8083 8084 8085 8086 8087 8088 8089 8090 8091 8480 8481 8485 8888 9000 9001 9010 9083 9090 9095 9290 9994 9995 9996 9997 9998 9999
#ADD tmp/parcel-repo /opt/cloudera/parcel-repo
CMD ["/cmstart.sh"]
