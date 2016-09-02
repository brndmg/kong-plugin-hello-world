DEV_ROCKS = busted luacheck lua-llthreads2
BUSTED_ARGS ?= -o gtest -v --exclude-tags=ci
TEST_CMD ?= bin/busted $(BUSTED_ARGS)
KONG_PATH ?=/kong
PLUGIN_NAME := kong-plugin-hello-world

.PHONY: install uninstall dev lint test test-integration test-plugins test-all clean

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))
DEV_PACKAGE_PATH := $(current_dir)lua_modules/share/lua/5.1/?

define set_env
	@eval $$(luarocks path); \
	LUA_PATH="$(DEV_PACKAGE_PATH).lua;$$LUA_PATH" LUA_CPATH="$(DEV_PACKAGE_PATH).so;$$LUA_CPATH"; \
	cd $(KONG_PATH);
endef

dev: install
	@for rock in $(DEV_ROCKS) ; do \
		if ! command -v $$rock > /dev/null ; then \
      echo $$rock not found, installing via luarocks... ; \
      luarocks install $$rock ; \
    else \
      echo $$rock already installed, skipping ; \
    fi \
	done;

lint:
	@luacheck -q . \
						--exclude-files 'kong/vendor/**/*.lua' \
						--exclude-files 'spec/fixtures/invalid-module.lua' \
						--std 'ngx_lua+busted' \
						--globals '_KONG' \
						--globals 'ngx' \
						--globals 'assert' \
						--no-redefined \
						--no-unused-args

install:
	sudo luarocks make $(PLUGIN_NAME)-*.rockspec

uninstall:
	sudo luarocks remove $(PLUGIN_NAME)-*.rockspec

install-dev: dev
	luarocks make --tree lua_modules $(PLUGIN_NAME)-*.rockspec

test: install-dev
	$(call set_env) \
	$(TEST_CMD) $(current_dir)spec/01-unit

test-integration: install-dev
	$(call set_env) \
	$(TEST_CMD) $(current_dir)spec/02-integration

test-all: install-dev
	$(call set_env) \
	$(TEST_CMD) $(current_dir)spec/

clean:
	@echo "removing $(PLUGIN_NAME)"
	-@luarocks remove --tree lua_modules $(PLUGIN_NAME)-*.rockspec >/dev/null 2>&1 ||:
