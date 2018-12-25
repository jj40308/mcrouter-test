#!/bin/bash
memcached_set(){
    dataBytes=`printf $2 | wc -c`
    host_port=`get_docker_host_port $3`
    (echo -e 'set '"$1"' 0 0 '"$dataBytes"'\n'"$2"'\nquit'; sleep 1) | telnet localhost $host_port
}

memcached_get(){
    host_port=`get_docker_host_port $2`
    (echo -e 'get '"$1"''; sleep 1) | telnet localhost $host_port
}

memcached_del(){
    host_port=`get_docker_host_port $2`
    (echo -e 'delete '"$1"''; sleep 1) | telnet localhost $host_port
}

get_docker_host_port(){
    docker inspect $1 | grep HostPort | sed -n 2p | awk '{print $2}' | sed 's/"//g'
}
