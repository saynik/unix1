#!/bin/bash

file_1='./beverly_hills.txt'
file_2='./actor.txt'
file_3='./social.txt'

cat $file_1 $file_2 | sort | uniq -d | cat - $file_3 | sort | uniq -d
