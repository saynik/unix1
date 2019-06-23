#!/bin/sed -nuf

/[0-9]\+\s*+\s*[0-9]\+/ {
:start
    h
:strip_right
    s/\([0-9]\+\s*+\s*[0-9]\+\).*/~~~\1/
:strip_left
    s/^[^~]*~~~//
:prepare_sum_a
    s/0*\([0-9]\+\)\s*+\s*0*\([0-9]\+\)/,\1 \2/
:prepare_sum_b
    s/,\([0-9]*\)\([0-9]\) \([0-9]*\)\([0-9]\)/\2\4,\1 \3/
    t prepare_sum_b
:trailing_zeros
    s/, \([0-9]\+\)$/,0 \1/
    t prepare_sum_b
    s/,\([0-9]\+\) $/,\1 0/
    t prepare_sum_b
:strip_leftovers
    s/,\s*$//
:begin_sum
    s/^\([0-9]\{2\}\)\(.*\)/,0\1:\2/
:transform
    s/,\([X0-9]*\)0:/,\1:/
    s/,\([X0-9]*\)1:/,X\1:/
    s/,\([X0-9]*\)2:/,XX\1:/
    s/,\([X0-9]*\)3:/,XXX\1:/
    s/,\([X0-9]*\)4:/,XXXX\1:/
    s/,\([X0-9]*\)5:/,XXXXX\1:/
    s/,\([X0-9]*\)6:/,XXXXXX\1:/
    s/,\([X0-9]*\)7:/,XXXXXXX\1:/
    s/,\([X0-9]*\)8:/,XXXXXXXX\1:/
    s/,\([X0-9]*\)9:/,XXXXXXXXX\1:/
    t transform
:remainder
    s/\(X\{10\}\):/1:/
    t sum
:no_remainder
    s/\(X\{0,9\}\):/\10:/
:sum
    s/,\([01]\):/,0\1:/
    s/,X\{1\}\([01]\):/,1\1:/
    s/,X\{2\}\([01]\):/,2\1:/
    s/,X\{3\}\([01]\):/,3\1:/
    s/,X\{4\}\([01]\):/,4\1:/
    s/,X\{5\}\([01]\):/,5\1:/
    s/,X\{6\}\([01]\):/,6\1:/
    s/,X\{7\}\([01]\):/,7\1:/
    s/,X\{8\}\([01]\):/,8\1:/
    s/,X\{9\}\([01]\):/,9\1:/
:transfer
    s/\([^,]*\),\([^:]\)/\2\1,/
    # Without the following it simply does not work. I somehow need to clear the "successful substition" flag.
    t next_pair 
:next_pair
    s/,\([01]\):\([0-9]\{2\}\)/,\1\2:/
    t transform
:transfer_remainder
    s/\(.*\),0:/\1/
    s/\(.*\),1:/1\1/
:append_original
    G
:mark_original_sum
    s/[0-9]\+\s*+\s*[0-9]\+/~~~/
    t replace_original_sum
:replace_original_sum
    s/^\([0-9]\+\)\n\(.*\)~~~\(.*\)/\2\1\3/
    t test_not_end
:test_not_end
    s/[0-9]\+\s*+\s*[0-9]\+/&/
    t start
    p
    d
}

{
    p
}