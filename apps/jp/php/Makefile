export LANG := C.UTF-8
export LC_ALL := C.UTF-8
export COMPOSER_ALLOW_SUPERUSER := 1

# phpstan/phpstan は dist（GitHub の zip）しか配布されず、この環境では取得できないため
# composer ではなく PATH 上の phpstan か、PHPSTAN=path/to/phpstan.phar を指定して使う
PHPSTAN ?= phpstan

# GitHub の zip を取得できない環境では COMPOSER_FLAGS=--prefer-source を指定する
COMPOSER_FLAGS ?=

.PHONY: install test lint analyse complexity check

vendor/autoload.php: composer.json
	composer install $(COMPOSER_FLAGS) --no-interaction --no-progress
	touch $@

install: vendor/autoload.php

test: vendor/autoload.php
	vendor/bin/phpunit

lint: vendor/autoload.php
	vendor/bin/phpcs

analyse: vendor/autoload.php
	$(PHPSTAN) analyse --no-progress

complexity: vendor/autoload.php
	vendor/bin/phpmd src text phpmd.xml

check: lint analyse complexity test
