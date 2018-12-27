#!/usr/bin/env bats
load ../test_helpers/memcached_test_helper
teardown() {
    revert_config_file_default
    remove_test_cache_data $serversCount $key
    [ -n "$output" ]
}

@test "mcrouter set all test" {
    set_config_file all_fatest_test
    key='rj'
    value='r'
    serversCount=3
    run memcached_set $key $value 'mcrouter'
    [ "${lines[3]}" = "STORED" ]
    for (( i=0; i<serversCount; i++ ))
    do
        run memcached_get $key 'memcached'$i
        [ "${lines[3]}" = "VALUE rj 0 1" ]
        [ "${lines[4]}" = "r" ]
    done
} 

@test "mcrouter warm cold route test" {
    set_config_file warm_cold_test 
    key='gw'
    value='g'
    serversCount=3
    run memcached_set $key $value 'memcached0'
    [ "${lines[3]}" = "STORED" ]

    run memcached_get $key 'memcached2'
    [ "${lines[3]}" = "END" ]

    run memcached_get $key 'mcrouter'
    [ "${lines[3]}" = "VALUE gw 0 1" ]
    [ "${lines[4]}" = "g" ]

    run memcached_get $key 'memcached2'
    [ "${lines[3]}" = "VALUE gw 0 1" ]
    [ "${lines[4]}" = "g" ]
}
