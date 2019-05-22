#!/bin/bash

read var
all=${var}

numbers=( $( echo ${all[@]} | sed 's/\+/ \+ /g' | sed 's/[^0-9*\+0-9*]/ /g' ) )

sum_f () {
    obj=( ${@} )
    summing=$(( $1 + $2 ))
#    var=$( echo ${var} | sed "s/[$1]\s*[\+]\s*[$2]/$summing/g" )
    var=$( echo ${var} | sed "s/$1.*[\+]*.$2/$summing/g" )
}

for i in ${!numbers[@]} ; do
    
    if [ "${numbers[$i]}" == '+' ] ; then
        sum_f ${numbers[$(($i - 1 ))]} ${numbers[$(( $i + 1 ))]} 
    fi     
done

echo $var
