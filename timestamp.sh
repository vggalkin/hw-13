#!/bin/bash

find /var/log/ -name "*.log" -type f | while read file; do
    dir=$(dirname "$file")
    base=$(basename "$file" .log)
    timestamp=$(stat -c '%Y' $file)
    mv "$file" "$dir/${base}_{${timestamp}}.log"
done

