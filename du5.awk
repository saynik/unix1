#!/usr/bin/awk -f

BEGIN {
    RS="<";
    FS="=";
}

/^[Aa](\s+[^=]*[-_a-zA-Z0-9]+\s*=\s*(("[^"]*")|('[^']*')|([^\s>]+)))*\s+[^=]*[hH][rR][eE][fF]\s*=\s*(("[^"]*")|('[^']*')|([^\s>]+))(\s|>)/ {
    # Find HREF fields
    hrefFieldIndex = 1;
    valueFieldIndex = 2;
    hrefRegex = "\\s+[hH][rR][eE][fF]\\s*";
    valueRegex = "\\s*(\"[^\"]*\")|('[^']*')|([^\\s>]+)(\\s|>)";
    # HREF field must match its regex AND
    # value field must match its regex AND
    # value field MUST NOT match HREF regex, otherwise this would match as well <a style='href="hello"'>test</a>
    while ((hrefFieldIndex < NF) && !(match($(hrefFieldIndex), hrefRegex) && match($(valueFieldIndex), valueRegex) && !match($(valueFieldIndex), hrefRegex))) {
        hrefFieldIndex++;
        valueFieldIndex++;
    }
    value = $(valueFieldIndex);
    # Find the end of leading whitespace
    match(value, /\S/);
    if (RSTART > 0) {
        # Strip whitepace
        value = substr(value, RSTART);
        # Determine quoting type
        firstChar = substr(value, 1, 1);
        endIndex = 0;
        if (match(firstChar, /['"]/)) {
            # Quoted
            value = substr(value, 2);
            endIndex = index(value, firstChar);
        } else {
            # Not quoted
            endIndex = match(value, /[\s>$]/);
        }
        # Strip trailing quote
        if (endIndex > 0) {
            value = substr(value, 1, endIndex - 1);
            # Replace basic XML entities
            gsub("&amp;", "\\&", value);
            gsub("&quot;", "\"", value);
            gsub("&lt;", "<", value);
            gsub("&gt;", ">", value);
            print value;
        }
    }
}