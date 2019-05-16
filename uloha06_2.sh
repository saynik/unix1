#!/bin/bash

join -t';' -1 1 -2 4 <( sort -t";" -k 1 countrycodes_en.csv ) <( sort -t";" -k 4 kodyzemi_cz.csv )
