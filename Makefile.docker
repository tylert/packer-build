SHELL := /usr/bin/env bash

BUILD_DIR ?= build
BUILDER ?= vbox  # vbox or qemu
BUILD_OPTS ?=  # leave this undefined unless needed
OS_NAME ?= debian
OS_VERSION ?= 10_buster
PACKER_CACHE_DIR ?= packer_cache
PYTHON ?= python3
TEMPLATE ?= base-uefi
TEMPLATE_DIR ?= template

.SUFFIXES:
.SUFFIXES: .yaml .json .iso .preseed .vagrant .ova .box

.PRECIOUS: .yaml .preseed .vagrant

.PHONY: all
all:

.PHONY: generator builder
generator: Dockerfile
	@docker build \
    --file Dockerfile \
    --tag $@ \
    --target $@ \
    .

# Don't depend on source files, always regenerate templates!!!
$(TEMPLATE_DIR): generator
	@docker run \
    --interactive \
    --rm \
    --tty \
    --volume $(PWD)/$(SOURCE_DIR):/tmp/$(SOURCE_DIR) \
    --volume $(PWD)/$(TEMPLATE_DIR):/tmp/$(TEMPLATE_DIR) \
    generator

.PHONY: build
build: $(TEMPLATE_DIR)
	@CHECKPOINT_DISABLE=1 PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) \
  packer build $(BUILD_OPTS) -only=$(BUILDER) -force $(TEMPLATE_DIR)/$(OS_NAME)/$(OS_VERSION)/$(TEMPLATE).json

# PACKER_CACHE_DIR=packer_cache
# PACKER_CONFIG="${HOME}/.packerconfig"
# PACKER_LOG=1
# PACKER_LOG_PATH=vbox.log
# PACKER_NO_COLOR=0
# PACKER_PLUGIN_MAX_PORT=25000
# PACKER_PLUGIN_MIN_PORT=10000
# PACKER_TMP_DIR=/tmp/packer.d
# TMPDIR=/tmp

.PHONY: clean
clean:
	@rm -rf $(TEMPLATE_DIR) $(BUILD_DIR) && \
  rm -rf Vagrantfile .vagrant

.PHONY: reallyclean
reallyclean: clean
	@rm -rf $(PACKER_CACHE_DIR)
