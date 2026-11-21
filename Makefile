STYLUA ?= stylua
NVIM ?= nvim
VIM ?= vim

.PHONY: all gen test test-vim fmt lint

all: gen test test-vim

# regenerate colors/tanuki-night.vim, extras/nvchad, extras/<terminal>
gen:
	$(NVIM) --headless -u NONE -l scripts/gen_vim.lua
	$(NVIM) --headless -u NONE -l scripts/gen_nvchad.lua
	$(NVIM) --headless -u NONE -l scripts/gen_extras.lua

test:
	$(NVIM) --headless -u NONE -l tests/run.lua

# generated colors/*.vim in plain Vim
test-vim:
	$(VIM) -N -u NONE -i NONE -es -S tests/run.vim </dev/null

fmt:
	$(STYLUA) lua colors scripts tests

lint:
	$(STYLUA) --check lua colors scripts tests
