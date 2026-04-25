.PHONY: help setup test lint lint-fix format analyse complexity check coverage

help: ## タスク一覧を表示
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "%-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## 依存関係をインストール
	composer install

test: ## テストを実行
	composer test

lint: ## コーディング規約チェック
	composer lint

lint-fix: ## コーディング規約を自動修正
	composer lint:fix

format: ## コーディング規約を自動修正
	composer format

analyse: ## PHPStan 静的解析
	composer analyse

complexity: ## PHPMD 複雑度チェック
	composer complexity

check: ## 全品質チェック
	composer check

coverage: ## テストカバレッジを表示
	composer test:coverage
