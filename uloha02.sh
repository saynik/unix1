#!/bin/bash

key="$1"

args=( )

for i in "$@" ; do
    args+=( "$1" ) ; shift
done

keys=(
    --normal
    --reverse
    --subst
    --len
    --help
)

action=(
    normal_func
    reverse_func
    subst_func
    len_func
    help_func
)

help_info=(
    "displays the arguments in direct order"
    "displays the arguments in reverse order"
    "variable substitution is called"
    "displays the number of arguments"
    "display this help and exit"
)

normal_func () {
    for obj in "${args[@]}"; do
        echo "$obj"
    done
}

reverse_func () {
    min=0 ; max=$(( ${#args[@]} - 1 ))
    while [[ min -lt max ]]; do
        x="${args[$min]}"
        args[$min]="${args[$max]}"
        args[$max]="$x"
        (( min++, max-- ))
    done
    for i in "${args[@]}" ; do echo $i ; done
 
}

len_func () {
    value_len=( )
    for obj in "${args[@]}"; do
        value_len+=( "${#obj}" )
    done
    echo ${value_len[@]}
}

subst_func () {
    for obj in "${args[@]:3}"; do
        echo $obj | sed "s/${args[@]:1:1}/${args[@]:2:1}/g"
    done
}

help_func () {
    echo "Syntax: uloha02.sh [options] [args]"
    for id in "${!keys[@]}" ; do
        echo -e "\t ${keys[$id]} ${help_info[$id]}"
    done 
}

main () {
    for id in ${!keys[@]}; do
        if [ "${keys[id]}" == "$key" ] ; then
            ${action[id]}
            break
        fi
    done
}

main
