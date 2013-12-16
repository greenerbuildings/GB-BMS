#!/bin/bash
clear
echo "starting cassandra deamon"
echo "-------------------------"

cd /home/actlab/build-cassandra/cassandra-trunk2/bin

(./cassandra >& /dev/null &) < /dev/null

sleep 20

echo "starting REST server"
echo "-------------------------"
cd /home/actlab/build-cassandra/myCassandraManager/dlib-17.48/examples/build/
#next export library and run server
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:~/build-cassandra/myCassandraManager/lib

(./rest_server_DL >& /dev/null &) < /dev/null
