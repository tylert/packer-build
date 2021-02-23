SHELL := /usr/bin/env bash

# BUILDER should be 'vbox' or 'qemu'
# BUILD_OPTS and GEN_OPTS should be undefined unless needed

BUILDER ?= vbox
BUILD_OPTS ?=
GEN_OPTS ?=
OS_NAME ?= debian
OS_VERSION ?= 10_buster
PACKER_CACHE_DIR ?= packer_cache
TEMPLATE ?= base-uefi

PYTHON ?= python
VENV_DIR ?= .venv

SOURCE_DIR ?= source
TEMPLATE_DIR ?= template
BUILD_DIR ?= build

.SUFFIXES:
.SUFFIXES: .yaml .preseed .vagrant .json .iso .ova .box

.PRECIOUS: .yaml .preseed .vagrant

.PHONY: all
all: build

# XXX TODO FIXME  Remove once builds are containerized
ACTIVATE_SCRIPT = $(VENV_DIR)/bin/activate
.PHONY: venv
venv: $(ACTIVATE_SCRIPT)
$(ACTIVATE_SCRIPT): requirements.txt
	@test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR) && \
  source $(ACTIVATE_SCRIPT) && \
  pip install --upgrade --requirement requirements.txt && \
  touch $(ACTIVATE_SCRIPT)

# XXX TODO FIXME  Remove once builds are containerized
.PHONY: venv_upgrade
venv_upgrade: venv
	@source $(ACTIVATE_SCRIPT) && \
  pip install --upgrade --requirement requirements_bare.txt && \
  pip freeze > requirements.txt && \
  touch $(ACTIVATE_SCRIPT)

# XXX TODO FIXME  Remove once builds are containerized
# Don't depend on source files, always regenerate templates!!!
$(TEMPLATE_DIR): venv
	@source $(ACTIVATE_SCRIPT) && \
  $(PYTHON) generate_template.py

# XXX TODO FIXME  Remove once builds are containerized
.PHONY: build
build: $(TEMPLATE_DIR)
	@source $(ACTIVATE_SCRIPT) && \
  CHECKPOINT_DISABLE=1 PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) \
  packer build $(BUILD_OPTS) -only=$(BUILDER) -force $(TEMPLATE_DIR)/$(OS_NAME)/$(OS_VERSION)/$(TEMPLATE).json

# .PHONY: generator builder
# generator builder: Dockerfile requirements.txt generate_template.py
# 	@docker build \
#     --build-arg USER=$(shell id -u) \
#     --file Dockerfile \
#     --tag $@ \
#     --target $@ \
#     .

# $(TEMPLATE_DIR): generator
# 	@mkdir -p $(PWD)/$(TEMPLATE_DIR) && \
#   docker run \
#     --interactive \
#     --rm \
#     --volume $(PWD)/$(SOURCE_DIR):/tmp/$(SOURCE_DIR) \
#     --volume $(PWD)/$(TEMPLATE_DIR):/tmp/$(TEMPLATE_DIR) \
#     generator $(GEN_OPTS)

# XXX TODO FIXME  Containerize the builds too!
# .PHONY: build
# build: builder $(TEMPLATE_DIR)
# 	@docker run \
#     --interactive \
#     --rm \
#     --volume $(PWD)/$(BUILD_DIR):/tmp/$(BUILD_DIR) \
#     --volume $(PWD)/$(PACKER_CACHE_DIR):/tmp/$(PACKER_CACHE_DIR) \
#     --volume $(PWD)/$(TEMPLATE_DIR):/tmp/$(TEMPLATE_DIR) \
#     builder $(BUILD_OPTS)

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
	@rm -rf $(VENV_DIR)

.PHONY: reallyreallyclean
reallyreallyclean: reallyclean
	@rm -rf $(PACKER_CACHE_DIR)
