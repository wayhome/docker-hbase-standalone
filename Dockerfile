FROM dockerfile/java:oracle-java8
MAINTAINER Cogniteev <tech@cogniteev.com>

# ssh and supervisord
RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor

RUN echo 'root:test123' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


ENV HBASE_VERSION=0.98.10

RUN groupadd -r hbase && useradd -m -r -g hbase hbase
USER hbase
ENV HOME=/home/hbase
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Download'n extract hbase
RUN cd /home/hbase && \
    wget -O - -q \
    http://apache.mesi.com.ar/hbase/hbase-${HBASE_VERSION}/hbase-${HBASE_VERSION}-hadoop2-bin.tar.gz \
    | tar --strip-components=1 -zxf -

# Upload local configuration
ADD ./conf/ /home/hbase/conf/
# Prepare data volumes
RUN mkdir /home/hbase/data && mkdir /home/hbase/logs

VOLUME /home/hbase/data
VOLUME /home/hbase/logs
USER root
RUN chown -R hbase:hbase /home/hbase/conf




# zookeeper
EXPOSE 2181
# HBase Master API port
EXPOSE 60000
# HBase Master Web UI
EXPOSE 60010
# Regionserver API port
EXPOSE 60020
# HBase Regionserver web UI
EXPOSE 60030
# HBase thrift API
EXPOSE 9090
# SSH Port
EXPOSE 22

COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD /usr/bin/supervisord
