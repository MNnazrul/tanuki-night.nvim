STYLUA ?= stylua
NVIM ?= nvim

.PHONY: all gen test fmt lint

all: gen test

# regenerate colors/tanuki-night.vim, extras/nvchad, extras/<terminal>
gen:
	$(NVIM) --headless -u NONE -l scripts/gen_vim.lua
	$(NVIM) --headless -u NONE -l scripts/gen_nvchad.lua
	$(NVIM) --headless -u NONE -l scripts/gen_extras.lua

test:
	$(NVIM) --headless -u NONE -l tests/run.lua

fmt:
	$(STYLUA) lua colors scripts tests

lint:
	$(STYLUA) --check lua colors scripts tests
