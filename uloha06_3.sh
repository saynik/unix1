#!/bin/bash

data=( $( cat /etc/group ) )
output=( )

for ind in ${!data[@]}; do
    users=$( echo "${data[$ind]}" | sort | cut -d':' -f 4 )
    add=$(IFS=,; set -f; set -- $users; echo $#)
    output+=( ${add}-$ind )
done

max()
{
    IFS=$'\n'
    sorted=( $( echo "${output[*]}" | sort -nr ) )
    count=0
    for ind in ${sorted[@]}; do
        nv=$(( $count + 1 ))
        if [ "$( echo ${sorted[$count]} | cut -d'-' -f1 )" -eq "$( echo ${sorted[$nv]} | cut -d'-' -f1)" ] ; then
            echo ${data[ $( echo ${sorted[$count]} | cut -d'-' -f 2 ) ]}
        else
            echo ${data[ $( echo ${sorted[$count]} | cut -d'-' -f 2 ) ]}
            exit 0
        fi
        (( count ++))
    done
}

max
