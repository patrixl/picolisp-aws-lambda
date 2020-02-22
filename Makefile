# picolisp-aws-lambda Makefile
# Credit goes to Alex Williams

PIL_MODULE_DIR ?= .modules
REPO_PREFIX ?= https://github.com/

# Unit testing
TEST_REPO = $(REPO_PREFIX)/aw/picolisp-unit.git
TEST_DIR = $(PIL_MODULE_DIR)/picolisp-unit/HEAD
JSON_REPO = $(REPO_PREFIX)/aw/picolisp-json.git
JSON_DIR = $(PIL_MODULE_DIR)/picolisp-json/HEAD
AWS_REPO = $(REPO_PREFIX)/aw/picolisp-awscurl.git
AWS_DIR = $(PIL_MODULE_DIR)/picolisp-awscurl/HEAD
TEST_REF = v3.0.0

.PHONY: all

all: check

$(TEST_DIR):
		mkdir -p $(TEST_DIR) && \
		git clone --depth 1 $(TEST_REPO) $(TEST_DIR) && \
		git clone --depth 1 $(JSON_REPO) $(JSON_DIR) && \
		git clone --depth 1 $(AWS_REPO) $(AWS_DIR) && \
		cd $(TEST_DIR) && \
		git checkout $(TEST_REF)

check: $(TEST_DIR) run-tests

run-tests:
		pil ./test.l -test-runtime -bye
