## Docker HBase Standalone Dockerfile

This repository contains **Dockerfile** of [Hbase 0.98.10](http://hbase.apache.org/) for [Docker](https://www.docker.com/) [automated build](https://registry.hub.docker.com/u/cogniteev/hbase-standalone/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

### Base Docker Image

* [dockerfile/java:oracle-java8](http://dockerfile.github.io/#/java)

### Installation

1. Install [Docker](https://www.docker.com/)

2. Download [trusted build](https://registry.hub.docker.com/u/cogniteev/hbase-standalone/): `docker pull cogniteev/hbase-standalone`

### Usage

```sh
docker run -d -p 2181:2181 -p 60000:60000 -p 60010:60010 -p 60020:60020 -p 60030:60030 cogniteev/hbase-standalone
```

Open http://docker.ip.add.ress:60010 in a browser

### Attach persistent/shared directories

Create a mountable data directory <data-dir> on the host.

Start the container with the following volume:
```sh
docker run -d -p 9200:9200 -p 9300:9300 -v <data-dir>:/home/hbase/data
```

### Notes

This container runs the exact version distributed by Apache.
