#!/usr/bin/awk -f

BEGIN{
RS="</a>"
IGNORECASE=1
}
{
  for(o=1;o<=NF;o++){
    if ( $o ~ /href/){
      gsub(/.*href=\042/,"",$o)
      gsub(/\042.*/,"",$o)
      print $(o)
    }
  }
}
