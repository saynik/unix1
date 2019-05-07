#!/bin/bash

source="https://blackhole.sk/~kabel/unix/index.html"

obj=$( curl $source )

echo "$obj" | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' 
