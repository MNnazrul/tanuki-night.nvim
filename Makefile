STYLUA ?= stylua
NVIM ?= nvim
VIM ?= vim
TS_DIR ?= .tests/ts
NVIM_TS ?= .tests/nvim-treesitter

.PHONY: all gen test test-vim test-queries parsers fmt lint

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

# queries/*.scm against real parsers (run `make parsers` first)
test-queries:
	$(NVIM) --headless -u NONE -l tests/queries.lua $(TS_DIR)

# build the parsers for test-queries into $(TS_DIR)
# (needs git, a C compiler and the tree-sitter CLI)
parsers:
	test -d $(NVIM_TS) || git clone --depth 1 --branch main https://github.com/nvim-treesitter/nvim-treesitter $(NVIM_TS)
	$(NVIM) --headless -u NONE -l scripts/install_parsers.lua $(NVIM_TS) $(TS_DIR)

fmt:
	$(STYLUA) lua colors scripts tests

lint:
	$(STYLUA) --check lua colors scripts tests
