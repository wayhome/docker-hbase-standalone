FROM dockerfile/java:oracle-java8
MAINTAINER Cogniteev <tech@cogniteev.com>

ENV HBASE_VERSION=0.98.10

RUN groupadd -r hbase && useradd -m -r -g hbase hbase
RUN apt-get update && apt-get install -y openssh-server supervisor
RUN mkdir -p /var/run/sshd /var/log/supervisor

USER hbase
ENV HOME=/home/hbase

# Download'n extract hbase
RUN cd /home/hbase && \
    wget -O - -q \
    http://apache.mesi.com.ar/hbase/hbase-${HBASE_VERSION}/hbase-${HBASE_VERSION}-hadoop2-bin.tar.gz \
    | tar --strip-components=1 -zxf -

# Upload local configuration
ADD ./conf/ /home/hbase/conf/
USER root
RUN chown -R hbase:hbase /home/hbase/conf
USER hbase

# Prepare data volumes
RUN mkdir /home/hbase/data
RUN mkdir /home/hbase/logs

VOLUME /home/hbase/data
VOLUME /home/hbase/logs

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

COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
WORKDIR /home/hbase
CMD /usr/bin/supervisord
