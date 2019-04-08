#!/bin/bash

declare -A arr

arr=( ['b']='block device'
     ['c']='character device'
     ['d']='folder'
     ['p']='fifo'
     ['L']='symbol link'
     ['f']='file'
     ['S']='socket' )

info () {
    printf "${@}\n"
}

cheeker () {
    obj="$1" ;
    for i in ${!arr[@]}; do 
       if test "-$i" "$obj" ; then
           info "${arr[$i]}" && exit 1
       fi
    done
    info "File not found" && exit 1
}

main () {
    if [ "$1" == "--typ" ] ; then
        cheeker $2
    elif [ "$1" == "--help" ] ; then
        info "Usage: uloha01.sh [--typ | --help] [path to file]
--typ check type object
--help display this help and exit"
    else 
        info "Usage key '--help'"
    fi
}


main "$1" "$2"
