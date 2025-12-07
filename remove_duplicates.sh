#!/bin/bash

remove_duplicate_words() {
    local text="$1"
    echo "$text" | sed -E '
        s/([[:alpha:]]+)[[:punct:][:space:]]+\1([[:punct:][:space:]]|$)/\1\2/gi; s/  +/ /g; s/ ,/,/g; s/ \././g
    '
}

# Использование
remove_duplicate_words "Довольно распространенная ошибка ошибка - это лишний повтор повтор слова слова. Смешно, не правда ли? Не нужно портить хор хоровод."

