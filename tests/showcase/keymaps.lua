local M = {}

-- Map several keys at once with shared options.
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

function M.setup(opts)
  opts = vim.tbl_extend("force", { leader = " " }, opts or {})
  vim.g.mapleader = opts.leader

  map("n", "<leader>w", "<cmd>write<cr>", "Save file")
  map("n", "<leader>q", "<cmd>quit<cr>", "Quit window")
  for i = 1, 9 do
    map("n", "<leader>" .. i, i .. "gt", "Go to tab " .. i)
  end
  return true
end

return M
