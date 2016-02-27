# PHP Git Hooks

Installs a pre-commit script to run all the scripts in this project.

- Banned words
- PHP-CS-FIXER

## Installation

Install with composer:

    composer require olorton/php-git-hooks
    
Then install the pre-commit hook:

    vendor/olorton/php-git-hooks/install.sh

## TODO/Roadmap

### 0.1

- Remove full path string when error found in one of the scripts
- Make banned words script load words from a file in the project route
- Load php-cs-fixer arguments from a file in the project route

### 0.2

- Load custom pre-commit hooks from the project's bin folder

## Licence

[MIT](./LICENSE)
