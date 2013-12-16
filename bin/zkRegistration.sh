#!/bin/bash

# Script that will register a Service into a zookeeper server and unregister it
# when the service has stopped.
# Thanks to http://www.linuxjournal.com/content/using-named-pipes-fifos-bash 

## Use: zkRegistration.sh [-n node_name]  zk_host_list service zk_node zk_pay_load
## Where:
##    zk_host_list: List of zookeeper hosts with their reapective ports
##                  zkhost_ip:zkhost_port[,zkhost_ip:zkhost_port]
##    service:      Name of the service to be registered, like in the -C 
##                  parameter for the ps command. Also a pattern is accepted.
##    zk_node:      Node where to create registration
##    zk_pay_load:  String containing the information that will be registered in
##                  ZooKeeper.
## 
## Optional parameters:
##    -n node_name  Adds a second node that contains the same information but
##                  using a friendlier name.

p_name=""
while true
do
  case $1 in
    "-n") p_name=$2;shift;shift;break;;
    *) break;;  
  esac 
done

case ${1:-help} in
 "help")
    cat $0 | awk '/^##/{print $0}' | sed -e 's/## //'
    exit 1
esac

# Check consistency in number of parameters
[[ ! $# -eq 4 ]] && echo "wrong number of parameters, run $0 help from more info " && exit 1

# Create pipe name to communicate zkcli_mt and this daemon
pipe=$(mktemp)
rm $pipe
zk_started=false
service_running=true
registration_active=true
function quit(){
  $zk_started && echo "quit" >& 3
  rm -f $pipe
  exit 0
}

trap "quit" EXIT SIGINT 2

if [[ ! -p $pipe ]]; then
    mkfifo $pipe
fi

# Detect PID of desired service
service_pid=(`ps -C $2 -o pid --no-headings || pgrep -f $2` )
[ X$service_pid == X ] && echo "Service $2 not found, test with ps -C $2 or pgrep -f $2" && exit 1

# Get Service name
service_name=$(ps -o comm -p $service_pid --no-headings)

# Verify base node exists
rc=$(cli_st $1 "cmd:ls $3" 2>&1 | awk -v pat="^$3" '$0 ~ pat{print $4}')
[[ ! X$rc == X0 ]] && echo "Node $3 does not exists in ZooKeeper" && exit 1
while true
do
  # Test if the service is running
  ! kill -0 ${service_pid[@]} 2>/dev/null && service_running=false

  if ! $service_running
  then
    $zk_started && echo "quit" >& 3 && zk_started=false
    service_pid=(`ps -C $2 -o pid --no-headings || pgrep -f $2` )
    service_name=$(ps -o comm -p $service_pid --no-headings)
    service_running=true
    sleep 5
    continue
  fi

  # test if Registration is stil valid
  [ X$(cli_st $1 "cmd:ls $3" 2>&1 | grep -v -P "(Batch|time =)" | grep -A1 $3 | wc -l) == X1 ] && registration_active=false 

  if ! $registration_active
  then
    $zk_started && echo "quit" >& 3 && zk_started=false && sleep 5
    registration_active=true
  fi
    
  # Test that the client is running, otherwise restart after sleeping
  if  ! $zk_started 
  then
    # Start ZooKeeper Client and connect to pipe. 
    cli_mt  $1 < $pipe 2>&1 > /dev/null & 
    exec 3>$pipe
    zk_pid=$! 
    zk_started=true
    sleep 2
    
    # Create the node
    echo "create +e ${3}/${service_name}_${service_pid}" >& 3
    echo "set ${3}/${service_name}_${service_pid} $4" >& 3
  fi 
  
  #Take a nap before next check up
  sleep 5
done
