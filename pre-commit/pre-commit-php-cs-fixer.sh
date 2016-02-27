#!/usr/bin/env bash

# Coding Standards fixer from http://cs.sensiolabs.org/ pre-commit hook for git
#
# Based on https://github.com/s0enke/git-hooks
#
# @author Soenke Ruempler <soenke@ruempler.eu>
# @author Sebastian Kaspari <s.kaspari@googlemail.com>

FILE_PATTERN="\.(php|phtml)$"
TMP_STAGING=".tmp_staging"

# stolen from template file
if git rev-parse --verify HEAD > /dev/null
then
    against=HEAD
else
    # Initial commit: diff against an empty tree object https://stackoverflow.com/questions/9765453/gits-semi-secret-empty-tree
    against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

# this is the magic:
# retrieve all files in staging area that are added, modified or renamed
# but no deletions etc
FILES=$(git diff-index --name-only --cached --diff-filter=ACMR $against -- )

if [ "$FILES" == "" ]; then
    exit 0
fi

# match files against whitelist
FILES_TO_CHECK=""
for FILE in $FILES
do
    echo "$FILE" | egrep -q "$FILE_PATTERN"
    RETVAL=$?
    if [ "$RETVAL" -eq "0" ]
    then
        FILES_TO_CHECK="$FILES_TO_CHECK $FILE"
    fi
done

if [ "$FILES_TO_CHECK" == "" ]; then
    exit 0
fi

# create temporary copy of staging area
if [ -e $TMP_STAGING ]; then
    rm -rf $TMP_STAGING
fi
mkdir $TMP_STAGING

# Copy contents of staged version of files to temporary staging area
# because we only want the staged version that will be commited and not
# the version in the working directory
STAGED_FILES=""
for FILE in $FILES_TO_CHECK
do
  ID=$(git diff-index --cached $against $FILE | cut -d " " -f4)

  # create staged version of file in temporary staging area with the same
  # path as the original file so that the phpcs ignore filters can be applied
  mkdir -p "$TMP_STAGING/$(dirname $FILE)"
  git cat-file blob $ID > "$TMP_STAGING/$FILE"
  STAGED_FILES="$STAGED_FILES $TMP_STAGING/$FILE"
done


#### Run the checks ####

RETVAL=0


##########  PHP CS Fixer  ##########
FIXDATA=`php vendor/fabpot/php-cs-fixer/php-cs-fixer fix $TMP_STAGING --dry-run`
FIXDATA=${FIXDATA/Checked all files*/}
if [ "$FIXDATA" != "" ]
then
  echo "One or more files do not conform to coding standards."
  echo "You can fix them by running the following commands:"
  echo
  echo cd `pwd`
  echo $FIXDATA | sed 's/[0-9 ]*[0-9]) /\
php vendor\/fabpot\/php-cs-fixer\/php-cs-fixer fix /g'
  echo
  RETVAL=1
fi


# delete temporary copy of staging area
rm -rf $TMP_STAGING

exit $RETVAL
