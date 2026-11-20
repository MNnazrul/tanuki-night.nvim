-- Render a file range to HTML with tanuki-night colors (for visual comparison).
-- nvim --headless -u NONE -l scripts/preview.lua <file> <first> <last> <out.html> [parser-rtp]
local file, first, last, out, extra = unpack(_G.arg)
vim.opt.rtp:prepend(vim.fn.getcwd())
if extra then
  vim.opt.rtp:append(extra)
end
vim.cmd("packadd nvim.tohtml")
vim.cmd("filetype on")
vim.cmd("colorscheme tanuki-night")
vim.cmd("edit " .. file)
vim.wo.number = true
local ok, err = pcall(vim.treesitter.start)
if not ok then
  print("treesitter: " .. tostring(err))
else
  vim.treesitter.get_parser():parse(true)
end
local lines = require("tohtml").tohtml(0, {
  range = { tonumber(first), tonumber(last) },
  number_lines = true,
  font = { "JetBrains Mono", "Menlo", "monospace" },
})
vim.fn.writefile(lines, out)
print("wrote " .. out)
