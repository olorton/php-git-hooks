#!/usr/bin/env bash

# Get root directory of git repo
PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Create symbolic link for pre-commit
cd $PROJECT_ROOT/.git/hooks/
ln -s ../../vendor/olorton/php-git-hooks/run.sh pre-commit
