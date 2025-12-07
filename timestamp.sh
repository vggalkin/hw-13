#!/bin/bash

find /var/log/ -name "*.log" -type f | while read file; do
    dir=$(dirname "$file")
    base=$(basename "$file" .log)
    timestamp=$(date +%Y%m%d_%H%M%S)
    mv "$file" "$dir/${base}_${timestamp}.log"
done

