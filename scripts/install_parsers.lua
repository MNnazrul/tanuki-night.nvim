-- Build the Treesitter parsers used by tests/queries.lua into a local folder.
-- Needs nvim-treesitter (main branch), the tree-sitter CLI and a C compiler.
--   nvim --headless -u NONE -l scripts/install_parsers.lua <nvim-treesitter dir> <install dir>
local nvim_ts, install_dir = _G.arg[1], _G.arg[2]
assert(nvim_ts and install_dir, "usage: install_parsers.lua <nvim-treesitter dir> <install dir>")
vim.opt.rtp:prepend(nvim_ts)

local langs = {}
for _, file in ipairs(vim.fn.glob("queries/*/highlights.scm", true, true)) do
  langs[#langs + 1] = file:match("queries/(.-)/")
end

require("nvim-treesitter").setup({ install_dir = install_dir })
local ok = require("nvim-treesitter").install(langs, { summary = true }):wait(30 * 60 * 1000)
if not ok then
  os.exit(1)
end
