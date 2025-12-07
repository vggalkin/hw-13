#!/bin/bash

PATH_ARG=$1
FN_NUMBER=$2

fn_timestamp() {
    local path="$1"
    if [[ ! -d "$path" ]]; then
        echo "Ошибка: директория '$path' не существует" >&2
        return 1
    fi
    
    find "$path" -name "*.log" -type f | while read -r file; do
        dir=$(dirname "$file")
        base=$(basename "$file" .log)
        if timestamp=$(stat -c '%Y' "$file" 2>/dev/null); then
            echo "$file" "$dir/${base}_${timestamp}.log"
        else
            echo "Ошибка: не удалось получить timestamp для файла '$file'" >&2
        fi
    done
}

fn_commit_hash() {
    local path="$1"
    if [[ ! -d "$path" ]]; then
        echo "Ошибка: директория '$path' не существует" >&2
        return 1
    fi
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Ошибка: текущая директория не является git репозиторием" >&2
        return 1
    fi
    
    find "$path" -name "*.py" -type f | while read -r file; do
        dir=$(dirname "$file")
        base=$(basename "$file" .py)
        if commit_hash=$(cd $PATH_ARG && git log --oneline --pretty=format:"%H" -1 -- "$file" 2>/dev/null); then
            if [[ -n "$commit_hash" ]]; then
                echo "$file" "$dir/${base}_${commit_hash}.py"
            else
                echo "$file" "$dir/${base}_uncommitted.py"
            fi
        else
            echo "Ошибка: не удалось получить commit hash для файла '$file'" >&2
        fi
    done
}

if [[ $# -ne 2 ]]; then
    echo "Использование: $0 {dir} {1 или 2}"
    echo "1 - запустить функцию fn_timestamp"
    echo "2 - запустить функцию fn_commit_hash"
    exit 1
fi

if [[ ! -d "$PATH_ARG" ]]; then
    echo "Ошибка: указанная директория '$PATH_ARG' не существует" >&2
    exit 1
fi

case "$FN_NUMBER" in
    1)
        fn_timestamp "$PATH_ARG"
        ;;
    2)
        fn_commit_hash "$PATH_ARG"
        ;;
    *)
        echo "Ошибка: второй аргумент должен быть 1 или 2" >&2
        exit 1
        ;;
esac
