SHELL=/bin/sh

.SHELLFLAGS = -e -c
.ONESHELL:
.PHONY: help

##@ General
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-50s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Mobile
test: ## Run flutter tests
	flutter test ./test

format: ## Format app files
	dart format . -l 120

format-check: ## Format app files, if any file is formatted then fail
	dart format . -l 120 --set-exit-if-changed

fix-issues: ## Fix automatically dart issues
	dart fix --apply