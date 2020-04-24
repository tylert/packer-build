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
VENV_DIR ?= .venv

.SUFFIXES:
.SUFFIXES: .yaml .json .iso .preseed .vagrant .ova .box

.PRECIOUS: .yaml .preseed .vagrant

.PHONY: all
all: build

ACTIVATE_SCRIPT = $(VENV_DIR)/bin/activate
.PHONY: venv
venv: $(ACTIVATE_SCRIPT)
$(ACTIVATE_SCRIPT): requirements.txt
	@test -d $(VENV_DIR) || $(PYTHON) -m venv $(VENV_DIR) && \
  source $(ACTIVATE_SCRIPT) && \
  pip install --upgrade --requirement requirements.txt && \
  touch $(ACTIVATE_SCRIPT)

.PHONY: venv_upgrade
venv_upgrade: venv
	@source $(ACTIVATE_SCRIPT) && \
  pip install --upgrade --requirement requirements_bare.txt && \
  pip freeze > requirements.txt && \
  touch $(ACTIVATE_SCRIPT)

# Don't depend on source files, always regenerate templates!!!
$(TEMPLATE_DIR): venv
	@source $(ACTIVATE_SCRIPT) && \
  $(PYTHON) generate_template.py

.PHONY: build
build: $(TEMPLATE_DIR)
	@source $(ACTIVATE_SCRIPT) && \
  CHECKPOINT_DISABLE=1 PACKER_CACHE_DIR=$(PACKER_CACHE_DIR) \
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
	@rm -rf $(VENV_DIR)

.PHONY: reallyreallyclean
reallyreallyclean: reallyclean
	@rm -rf $(PACKER_CACHE_DIR)
