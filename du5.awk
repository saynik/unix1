#!/usr/bin/awk -f

BEGIN {
    RS="<";
    FS="=";
}

/^[Aa](\s+[^=]*[-_a-zA-Z0-9]+\s*=\s*(("[^"]*")|('[^']*')|([^\s>]+)))*\s+[^=]*[hH][rR][eE][fF]\s*=\s*(("[^"]*")|('[^']*')|([^\s>]+))(\s|>)/ {
    hrefFieldIndex = 1;
    valueFieldIndex = 2;
    hrefRegex = "\\s+[hH][rR][eE][fF]\\s*";
    valueRegex = "\\s*(\"[^\"]*\")|('[^']*')|([^\\s>]+)(\\s|>)";
    while ((hrefFieldIndex < NF) && !(match($(hrefFieldIndex), hrefRegex) && match($(valueFieldIndex), valueRegex) && !match($(valueFieldIndex), hrefRegex))) {
        hrefFieldIndex++;
        valueFieldIndex++;
    }
    value = $(valueFieldIndex);
    match(value, /\S/);
    if (RSTART > 0) {
        value = substr(value, RSTART);
        firstChar = substr(value, 1, 1);
        endIndex = 0;
        if (match(firstChar, /['"]/)) {
            value = substr(value, 2);
            endIndex = index(value, firstChar);
        } else {
            endIndex = match(value, /[\s>$]/);
        }
        if (endIndex > 0) {
            value = substr(value, 1, endIndex - 1);
           gsub("&amp;", "\\&", value);
            gsub("&quot;", "\"", value);
            gsub("&lt;", "<", value);
            gsub("&gt;", ">", value);
            print value;
        }
    }
}