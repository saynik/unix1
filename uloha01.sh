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
    if [ "$1" == "--type" ] ; then
        cheeker $2
    elif [ "$1" == "--help" ] ; then
        info "Usege: cheker.sh [--type | --help] [path to file]
--type check type object
--help display this help and exit"
    else 
        info "Usege key '--help'"
    fi
}


main "$1" "$2"
