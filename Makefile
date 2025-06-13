BIN           := $(PWD)/.local/bin
PATH          := $(BIN):$(PATH)
SHELL         := env PATH=$(PATH) /bin/sh

# Versions
terraform_docs_version := 0.20.0

# Operating System and Architecture
os ?= $(shell uname|tr A-Z a-z)

ifeq ($(shell uname -m),x86_64)
  arch   ?= amd64
endif
ifeq ($(shell uname -m),arm64)
  arch   ?= arm64
endif

.PHONY: all
all: format lint docs test

.PHONY: tools
tools: $(BIN)/terraform-docs

# Setup terraform-docs
terraform_docs_package_name := terraform-docs-v$(terraform_docs_version)-$(os)-$(arch).tar.gz # Windows uses .zip as an extension.
terraform_docs_package_url  := https://github.com/terraform-docs/terraform-docs/releases/download/v$(terraform_docs_version)/$(terraform_docs_package_name)
terraform_docs_install_path := $(BIN)/terraform-docs-v$(terraform_docs_version)-$(os)-$(arch)

$(BIN)/terraform-docs:
	@mkdir -p $(BIN)
	@echo "Downloading terraform-docs $(terraform_docs_version) to $(terraform_docs_install_path)..."
	@curl --silent --show-error --fail --create-dirs --output-dir $(BIN) -O -L $(terraform_docs_package_url)
	@tar -C $(BIN) -xzf $(BIN)/$(terraform_docs_package_name) && rm $(BIN)/$(terraform_docs_package_name)
	@mv $(BIN)/terraform-docs $(terraform_docs_install_path)
	@ln -s $(terraform_docs_install_path) $(BIN)/terraform-docs

.PHONY: format
format: tools
	@echo "Formatting..."

.PHONY: lint
lint: tools
	@echo "Linting..."

.PHONY: docs
docs: tools
	@echo "Generating Docs..."
	@$(BIN)/./terraform-docs markdown table . --output-file README.md

.PHONY: test
test: tools
	@echo "Testing..."

.PHONY: clean
clean:
	@echo "Removing the $(BIN) directory..."
	@rm -rf $(BIN)
