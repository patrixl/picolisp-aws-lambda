# picolisp-aws-lambda Makefile
# Credit goes to Alex Williams

PIL_MODULE_DIR ?= .modules
REPO_PREFIX ?= https://github.com

# Unit testing
TEST_REPO = $(REPO_PREFIX)/aw/picolisp-unit.git
TEST_DIR = $(PIL_MODULE_DIR)/picolisp-unit/HEAD
JSON_REPO = $(REPO_PREFIX)/aw/picolisp-json.git
JSON_DIR = $(PIL_MODULE_DIR)/picolisp-json/HEAD
AWS_REPO = $(REPO_PREFIX)/aw/picolisp-awscurl.git
AWS_DIR = $(PIL_MODULE_DIR)/picolisp-awscurl/HEAD

.PHONY: all

all: check runtime

$(TEST_DIR):
		mkdir -p $(TEST_DIR) && \
		git clone --depth 1 $(TEST_REPO) $(TEST_DIR) && \
		git clone --depth 1 $(JSON_REPO) $(JSON_DIR) && \
		git clone --depth 1 $(AWS_REPO) $(AWS_DIR)

check: $(TEST_DIR) run-tests

run-tests:
		pil ./test.l -test-runtime -bye

runtime:
		./scripts/package.sh
