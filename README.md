# hawq-docker

Please refer to https://github.com/apache/hawq/tree/master/contrib/hawq-docker for original README

# Install docker
* following the instructions to install docker.
https://docs.docker.com/

# Setup build and test environment
* clone hawq repository
```
  git clone https://github.com/zhangweibin/docker-hawq.git
  cd docker-hawq
```
* Build the docker images
```
  sudo make build
``` 
(Command `make build` is to build docker images locally.)
* setup a 5 nodes virtual cluster for Apache HAWQ build and test.
```
  sudo make run
```
Now let's have a look about what we creted.
```
[root@localhost hawq-docker]# docker ps -a
CONTAINER ID        IMAGE                          COMMAND                CREATED             STATUS              PORTS               NAMES
382b2b3360d1        hawq/hawq-test:centos7   "entrypoint.sh bash"   2 minutes ago       Up 2 minutes                            centos7-datanode3
86513c331d45        hawq/hawq-test:centos7   "entrypoint.sh bash"   2 minutes ago       Up 2 minutes                            centos7-datanode2
c0ab10e46e4a        hawq/hawq-test:centos7   "entrypoint.sh bash"   2 minutes ago       Up 2 minutes                            centos7-datanode1
e27beea63953        hawq/hawq-test:centos7   "entrypoint.sh bash"   2 minutes ago       Up 2 minutes                            centos7-namenode
1f986959bd04        hawq/hawq-dev:centos7    "/bin/true"            2 minutes ago       Created                                 centos7-data
```
**centos7-data** is a data container and mounted to /data directory on all other containers to provide a shared storage for the cluster. 

# Build and Test Apache HAWQ
* build Apache HAWQ
```
  sudo make build-hawq
```
* Initialize Apache HAWQ cluster
```
  sudo make init-hawq
```
Now you can connect to database with `psql` command.
```
[gpadmin@centos7-namenode data]$ export PATH=/data/hawq-devel/bin:$PATH
[gpadmin@centos7-namenode data]$ psql -d postgres
psql (8.2.15)
Type "help" for help.

postgres=# 
```

# More command with this script
```
 Usage:
    To setup a build and test environment:         make run
    To start all containers:                       make start
    To stop all containers:                        make stop
    To remove hdfs containers:                     make clean
    To remove all containers:                      make distclean
    To build images locally:                       make build-image
    To pull latest images:                         make pull
    To build Hawq runtime:                         make build-hawq
    To initialize Hawq on Namenode:                make init-hawq
    To start Hawq on Namenode:                     make start-hawq
    To stop Hawq on Namenode:                      make stop-hawq
    To check Hawq status on Namenode:              make status-hawq
    To build PXF runtime:                          make build-pxf
    To initialize PXF on Namenode/Datanodes:       make init-pxf
    To start PXF on Namenode/Datanodes:            make start-pxf
    To stop PXF on on Namenode/Datanodes:          make stop-hawq
    To check PXF status on Namenode/Datanodes:     make status-hawq
```
