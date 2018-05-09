TEMPLATE_DIR ?= template
PACKER_CACHE_DIR ?= packer_cache
BUILD_DIR ?= build

.SUFFIXES: .yaml .json .iso .preseed .kickstart .ova .box

.PHONY: all
all:

.PHONY: clean
clean:
	@rm -rf $(TEMPLATE_DIR) $(BUILD_DIR)

.PHONY: reallyclean
reallyclean: clean
	@rm -rf $(PACKER_CACHE_DIR)
