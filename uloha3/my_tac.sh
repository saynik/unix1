#!/bin/bash 

array=( $* )

while read i; do
    data+=( ${i} )
done

array+=( ${data[@]} )

revers_array () {
    array_revers=("${@}")
    min=0 ; max=$(( ${#array_revers[@]} - 1 ))
    while [[ min -lt max ]]; do
        x="${array_revers[$min]}"
        array_revers[$min]="${array_revers[$max]}"
        array_revers[$max]="$x"
        (( min++, max-- ))
    done
    for i in "${array_revers[@]}" ; do echo $i ; done
}

n_revers_array () {
    n=$1 ; cuts=0
    revers_array "${array[@]:2}" &> /dev/null
    tmp_array_revers=("${array_revers[@]}")
    while [[ $cuts -le $(( ${#tmp_array_revers[@]} ))  ]] ; do
        revers_array ${tmp_array_revers[@]:$cuts:$n}
        cuts=$(( $cuts + $n ))
    done
}

if [ "${1::1}" != "-" ]; then
    revers_array "${array[@]}"
elif [ "${1::1}""n" == "-n" ]; then
    count=$2
    n_revers_array $count
fi

