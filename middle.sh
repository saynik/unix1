#!/bin/bash

#set -x

array=($*)

view_func () {
    for i in "${@}"; do
        echo $i
    done
}

cut_func () { 
    echo ${1} | cut -d"/" -f"$2"
}

lines_func () {
    if [ "${1::1}" -le "${1:2:2}" ]; then
        start=$(( ${1::1} + 1 ))
        ending=$(( ${1:2:2} - ${1::1} + 1 ))
        view_func "${@:$start:$ending}"
    else
        echo -e "Error param: \nparam2( you write ${1:2:2}) must be less equal > param1( you write ${1::1})"
    fi
}

fraction_func () {
    a=$( cut_func ${1} 1 ) ; b=$( cut_func ${1} 2 )
    c=$( cut_func ${2} 1 ) ; d=$( cut_func ${2} 2 )
    data=(${@:3})
    start=$( echo "if ( "$a"%"$b" ) $(( ( ${#data[@]} * $a / $b ) - 1 )) else $((  ( ${#data[@]} * $a / $b ) -1 )) "  | bc )
    ending=$(echo $(echo "${#data[@]} * $c / $d" | bc -l ) | awk '{printf("%d\n",$1 + 0.99)}')
    view_func "${data[@]:$start:$(( $ending - $start ))}"
}

part_func () {
    data=("${@:2}")
    part=$(echo $(echo "${#data[@]} / ${array[1]:2:2}" | bc -l ) | awk '{printf("%d\n",$1 + 0.99)}')
    start=$(( $part * ${array[1]::1} - $part ))
    view_func "${data[@]:$start:$part}"
}

echo "${array[1]:1}"

if [ "${1::1}" != "-" ]; then
    view_func ${array[@]}
elif [ "${array[0]}" == "-l" ] || [ "${array[0]}" == "--lines" ]; then
    lines_func "${array[@]:1}"
elif [ "${array[0]}" == "-f" ] || [ "${array[0]}" == "--fraction" ]; then
    fraction_func "${array[@]:1}"
elif [ "${array[0]}" == "-p" ] || [ "${array[0]}" == "--part" ]; then
    if [ ${array[1]:1:1} == "/" ] && [ "${array[1]:2:2}" != "0" ]; then
        part_func "${array[@]:1}" 
    elif [ ${array[1]:2:1} == "0" ]; then
        echo "Error value: var B don't must be equel 0"
    else 
        echo "Syntax error: must be write ( example A/B)"
    fi
elif [ "${array[1]:0:1}" == "-" ] ; then
    echo > ${array[1]:1}
fi
