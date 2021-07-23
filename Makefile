SHELL := /usr/bin/env bash

# BUILDER should be 'vbox' or 'qemu'
# BUILD_OPTS and GEN_OPTS should be undefined unless needed

BUILDER ?= vbox
BUILD_OPTS ?=
GEN_OPTS ?=
OS_NAME ?= debian
OS_VERSION ?= 10_buster
PACKER ?= packer
PACKER_CACHE_DIR ?= packer_cache
PYTHON ?= python
TEMPLATE ?= base-uefi
VENV_DIR ?= .venv

# PACKER_CACHE_DIR=packer_cache
# PACKER_CONFIG="${HOME}/.packerconfig"
# PACKER_LOG=1
# PACKER_LOG_PATH=vbox.log
# PACKER_NO_COLOR=0
# PACKER_PLUGIN_MAX_PORT=25000
# PACKER_PLUGIN_MIN_PORT=10000
# PACKER_TMP_DIR=/tmp/packer.d
# TMPDIR=/tmp

BUILD_DIR ?= build
SOURCE_DIR ?= source
TEMPLATE_DIR ?= template

.SUFFIXES:
.SUFFIXES: .yaml .preseed .vagrant .json .iso .ova .box

.PRECIOUS: .yaml .preseed .vagrant

.PHONY: all
all: build

ACTIVATE = $(VENV_DIR)/bin/activate
.PHONY: requirements
requirements: requirements_bare.txt
	@test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR) && \
    source $(ACTIVATE) && \
    $(PYTHON) -m pip install --requirement requirements_bare.txt && \
    $(PYTHON) -m pip freeze > requirements.txt && \
    rm -rf $(VENV_DIR)

.PHONY: generator builder
generator builder: Dockerfile requirements.txt generate_template.py
	@docker build \
    --build-arg USER=$(shell id -u) \
    --file Dockerfile \
    --tag $@ \
    --target $@ \
    .

$(TEMPLATE_DIR): generator
	@mkdir -p $(PWD)/$(TEMPLATE_DIR) && \
  docker run \
    --interactive \
    --rm \
    --volume $(PWD)/$(SOURCE_DIR):/tmp/$(SOURCE_DIR) \
    --volume $(PWD)/$(TEMPLATE_DIR):/tmp/$(TEMPLATE_DIR) \
    generator $(GEN_OPTS)

.PHONY: build
build: $(TEMPLATE_DIR)
	@CHECKPOINT_DISABLE=1 PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) \
  $(PACKER) build \
    $(BUILD_OPTS) \
    -only=$(BUILDER) \
    -force \
    $(TEMPLATE_DIR)/$(OS_NAME)/$(OS_VERSION)/$(TEMPLATE).json

# .PHONY: build
# build: builder $(TEMPLATE_DIR)
# 	@docker run \
#     --interactive \
#     --rm \
#     --volume $(PWD)/$(BUILD_DIR):/tmp/$(BUILD_DIR) \
#     --volume $(PWD)/$(PACKER_CACHE_DIR):/tmp/$(PACKER_CACHE_DIR) \
#     --volume $(PWD)/$(TEMPLATE_DIR):/tmp/$(TEMPLATE_DIR) \
#     builder $(BUILD_OPTS)

.PHONY: clean
clean:
	@rm -rf $(TEMPLATE_DIR) $(BUILD_DIR) && \
  rm -rf Vagrantfile .vagrant

.PHONY: reallyclean
reallyclean: clean
	@rm -rf $(PACKER_CACHE_DIR)
