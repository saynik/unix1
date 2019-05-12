#!/bin/bash

source="https://blackhole.sk/~kabel/unix/index.html"

curl $source > html_page.txt

awk 'NR>1{x[$1]++
}END{
for(i in x)print i}
' RS="<a[ \n]*href[ \n]*=[ \n]*\"" FS="\"" IGNORECASE=1 ./html_page.txt
