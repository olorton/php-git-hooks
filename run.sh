#!/usr/bin/env bash

# Get root directory of git repo
PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Run all the pre-commit hooks in this repo
FILES=${PROJECT_ROOT}/vendor/olorton/php-git-hooks/pre-commit/*
for FILE in $FILES
do
    $FILE
    if [ $? -ne 0 ]; then
        echo "pre-commit hook failed: $FILE"
        exit 1
    fi
done

exit 0
