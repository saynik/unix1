#!/bin/bash

read var
all=${var}
output=${var}

cheeker () {
    if echo $all | grep -o "[0-9]* [\+] [0-9]*" > /dev/null ; then
        number=( $( echo $all | grep -o "[0-9]* [\+] [0-9]*" ) )
        count="$(( ${#number[@]} / 3 ))"
        for i in $( seq 0 $(( $count - 1 )) ); do
              shift_var=$(( $i * 3  ))
              cal ${number[@]:$shift_var:3}
        done
        echo "$output"
    else
        echo "${all[@]}"
    fi 
}

cal () {
    obj=( $@ )
    result=$(( obj[0] ${obj[1]} obj[2] ))
    replace=${obj[@]}
    output=$( echo $output | sed "s/$replace/$result/" )
}

cheeker
 
