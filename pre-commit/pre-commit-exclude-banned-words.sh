#!/usr/bin/env bash

# TODO load this from a file in the root of the project
BANNED_WORDS="@wip"

if git rev-parse --verify HEAD > /dev/null
then
    against=HEAD
else
    # Initial commit: diff against an empty tree object https://stackoverflow.com/questions/9765453/gits-semi-secret-empty-tree
    against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

FILES=$(git diff-index --name-only --cached --diff-filter=ACMR $against -- )

if [ "$FILES" == "" ]; then
    exit 0
fi

for FILE in $FILES
do
    grep -q "${BANNED_WORDS// /\\|}" $FILE

    if [ $? -eq 0 ]; then
        # TODO also display what the word is
        echo "Banned word found in: $FILE"
        exit 1
    fi
done

exit 0
