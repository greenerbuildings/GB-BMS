#!/bin/bash
# global defaults settings
zk_host="129.125.84.113:2181"
zk_root=/gb/system
this_host=`ifconfig tun0 | awk '/inet addr/ {split ($2,A,":"); print A[2]}' `

# Repository settings
url_port_cassandra=7777
port_cassandra=9160
friendly_name_cassandra=repository
proc_name_pattern_cassandra="java.*cassa"

# Rabbit MQ settings
url_port_rmq=5672
port_rmq=5672
friendly_name_rmq=rabbitmq
proc_name_pattern_rmq=rabbitmq

#Functional part do not edit anything bellow this 
alias echo=`echo -e`
targets=$( echo ${!friendly_name_*} | sed -e "s|friendly_name_||g")
load=
function fill_load(){
  url=$host":"$url_port	
  load='{"url":"http://'$url'",
 "name":"'$name'",
 "port":"'$port'",
 "host":"'$host'"
}'
}

function register(){
  (exec 0<&-
   exec "$@") < /dev/null  2>&1 >/tmp/output & 
}

function start_registration(){
  [[ X$1 == Xall || $@ =~ " all " ]] && this_targets=$targets || this_targets=$@
  for app in $this_targets; do
    if  ! [[ $targets =~ $app ]] ; then
      echo $target is NOT a valid target, options are: $targets
      continue
    fi

    host=$this_host
    eval port=\$port_${app}
    eval url_port=\$url_port_${app}
    eval name=\$friendly_name_${app}
    fill_load
    eval pattern=\$proc_name_pattern_${app}
    echo registering: $name in  $zk_host
    register zkRegistration.sh -n $name $zk_host $pattern ${zk_root}/$name "`echo $load`"
  done
}
function stop(){
  [[ X$1 == Xall || $@ =~ " all " ]] && this_targets=$targets || this_targets=$@
  for app in $this_targets; do
    if  ! [[ $targets =~ $app ]] ; then
      echo $target is NOT a valid target, options are: $targets
      continue
    fi

    eval name=\$friendly_name_${app}
    eval pattern=\$proc_name_pattern_${app}
    kill  `pgrep -f zkRegistration.*$pattern`
  done
}
function status(){
  [[ X$1 == Xall || $@ =~ " all " ]] && this_targets=$targets || this_targets=$@
  for app in $this_targets; do
    if  ! [[ $targets =~ $app ]] ; then
      echo $target is NOT a valid target, options are: $targets
      continue
    fi

    eval name=\$friendly_name_${app}
    eval pattern=\$proc_name_pattern_${app}
    pgrep -f zkRegistration.*$pattern >& /dev/null && echo -e $name'\t\t''\e[0;32m'RUNNING'\e[0m' || echo -e  $name:'\t\t''\e[0;31m'STOPPED'\e[0m'
  done
}

#main
while true; do
  case ${1:-"quit"} in
    -z ) zk_host=$1 ;shift;;
    -r ) zk_root=$1 ;shift;;
    -i ) this_host=$1 ;shift;; 
    start ) shift
      start_registration $@
      break
      ;;
    status ) shift
      status $@
      break
      ;;
    stop ) shift
      stop $@
      break
      ;;
    -h | --help  ) echo this help ;break;;
    * ) break;;
  esac
done
