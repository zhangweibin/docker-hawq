#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

build() {
    git clone https://github.com/apache/hawq.git /data/hawq

    cd /data/hawq
    echo "Checking out branch 2.4.0.0 to build"
    git checkout 2.4.0.0
    ./configure --prefix=${HAWQ_HOME}
    # make -j16
    make
    make install

    sudo sed 's|LD_LIBRARY_PATH=|LD_LIBRARY_PATH=/usr/local/lib:|g' -i ${HAWQ_HOME}/greenplum_path.sh
    source ${HAWQ_HOME}/greenplum_path.sh

    sudo sed 's|localhost|centos7-namenode|g' -i ${GPHOME}/etc/hawq-site.xml
    sudo echo 'centos7-datanode1' >  ${GPHOME}/etc/slaves
    sudo echo 'centos7-datanode2' >> ${GPHOME}/etc/slaves
    sudo echo 'centos7-datanode3' >> ${GPHOME}/etc/slaves

    sudo -u hdfs hdfs dfs -chown gpadmin /

    echo "Build HAWQ Done!"
}

init() {
    source ${HAWQ_HOME}/greenplum_path.sh

    export BASEDIR=/data
    export HOME=/home/gpadmin
    export HOSTNAME=centos7-namenode
    export JAVA_HOME=/etc/alternatives/java_sdk
    export NAMENODE=${NAMENODE}
    export PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
    export PWD=/data
    export USER=gpadmin

    echo "Initializing HAWQ Cluster"
    hawq init cluster -a
    echo "Initializing HAWQ Cluster Done!"
}

start() {
    source ${HAWQ_HOME}/greenplum_path.sh
    echo "Starting HAWQ Cluster"
    hawq start cluster -a
    echo "Starting HAWQ Cluster Done!"
}

stop() {
    source ${HAWQ_HOME}/greenplum_path.sh
    echo "Stopping HAWQ Cluster"
    hawq stop cluster -a
    echo "Stopping HAWQ Cluster Done!"
}

status() {
    source ${HAWQ_HOME}/greenplum_path.sh
    echo "Getting HAWQ Cluster status"
    hawq state
    echo "Getting HAWQ Cluster status Done!"
}

case "$1" in
    '--build')
        build
        ;;
    '--init')
        init
        ;;
    '--start')
        start
        ;;
    '--stop')
        stop
        ;;
    '--status')
        status
        ;;
    *)
        echo "Usage: $0 {--build|--init|--start|--stop|--status}"
esac

exit 0
