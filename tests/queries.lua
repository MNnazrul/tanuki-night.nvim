-- Treesitter query tests: needs real parsers. Run from repo root:
--   make parsers          (once: builds parsers into .tests/ts with nvim-treesitter)
--   make test-queries
-- or directly:  nvim --headless -u NONE -l tests/queries.lua <dir with parser/ and queries/>
local ts_dir = _G.arg[1] or ".tests/ts"
vim.opt.rtp:prepend(vim.fn.getcwd())
vim.opt.rtp:append(ts_dir)
vim.cmd("filetype plugin on")

local failures = 0
local function check(name, cond, msg)
  if cond then
    io.stdout:write("ok   " .. name .. "\n")
  else
    failures = failures + 1
    io.stdout:write("FAIL " .. name .. (msg and (": " .. msg) or "") .. "\n")
  end
end

-- every queries/<lang>/highlights.scm compiles and is added to the default query
for _, file in ipairs(vim.fn.glob("queries/*/highlights.scm", true, true)) do
  local lang = file:match("queries/(.-)/")
  local has_parser = pcall(vim.treesitter.language.add, lang)
    and #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0
  if not has_parser then
    check(lang .. " parser installed", false, "run `make parsers`")
  else
    local first = io.lines(file)()
    check(lang .. " starts with ;; extends", first == ";; extends")
    local ok, query = pcall(vim.treesitter.query.get, lang, "highlights")
    check(lang .. " query compiles", ok and query ~= nil, not ok and tostring(query) or nil)
    local ours = vim.tbl_contains(
      vim.tbl_map(vim.fs.normalize, vim.treesitter.query.get_files(lang, "highlights")),
      vim.fs.normalize(vim.fn.fnamemodify(file, ":p"))
    )
    check(lang .. " query is used", ours)
  end
end

-- sample files highlight without errors in both styles
local samples = vim.fn.glob("tests/{samples,showcase}/*.*", true, true)
for _, style in ipairs({ "tanuki-night", "tanuki-day" }) do
  vim.cmd.colorscheme(style)
  for _, file in ipairs(samples) do
    vim.cmd("silent edit " .. vim.fn.fnameescape(file))
    local ok, err = pcall(function()
      vim.treesitter.start(0)
      vim.treesitter.get_parser(0):parse(true)
      vim.cmd("redraw")
    end)
    check(style .. " highlights " .. file, ok and vim.v.errmsg == "", err or vim.v.errmsg)
    vim.v.errmsg = ""
    vim.cmd("bwipeout!")
  end
end

io.stdout:write(("\n%d failure(s)\n"):format(failures))
if failures > 0 then
  os.exit(1)
end
