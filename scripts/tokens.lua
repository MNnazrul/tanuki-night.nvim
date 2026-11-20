-- Dump styled runs of a file range as JSON lines (for scripts/compare_light.py).
-- nvim --headless -u NONE -l scripts/tokens.lua <file> <first> <last> <style> [parser-rtp]
local file, first, last, style, extra = unpack(_G.arg)
first, last = tonumber(first), tonumber(last)
vim.opt.rtp:prepend(vim.fn.getcwd())
if extra and extra ~= "" then
  vim.opt.rtp:prepend(extra)
end
vim.cmd("filetype plugin on")
vim.cmd("syntax on")
vim.cmd("colorscheme tanuki-" .. style)
vim.treesitter.language.register("bash", { "sh", "bash", "zsh" })
vim.cmd("edit " .. vim.fn.fnameescape(file))
local ts = pcall(vim.treesitter.start)
if ts then
  vim.treesitter.get_parser():parse(true)
end

local function hl(group)
  local h = vim.api.nvim_get_hl(0, { name = group, link = false })
  return h.fg and ("#%06x"):format(h.fg), h.bold or false
end

-- Neovim resolves "@a.b.lang" -> "@a.b" -> "@a" when a group is undefined.
local function hl_fallback(group)
  local g = group
  while true do
    local h = vim.api.nvim_get_hl(0, { name = g, link = false })
    if next(h) ~= nil then
      return h.fg and ("#%06x"):format(h.fg), h.bold or false, true, h.nocombine or false
    end
    local cut = g:match("^(.*)%.[^.]+$")
    if not cut or cut == "" then
      return nil, false, false, false
    end
    g = cut
  end
end

local normal = hl("Normal")
local function style_at(row, col)
  local fg, bold, name = nil, false, "Normal"
  if ts then
    local caps = vim.treesitter.get_captures_at_pos(0, row, col)
    -- stable: Neovim applies equal-priority captures in query order
    for i, cap in ipairs(caps) do
      cap._i = i
    end
    table.sort(caps, function(a, b)
      local pa, pb = tonumber(a.metadata.priority) or 100, tonumber(b.metadata.priority) or 100
      if pa ~= pb then
        return pa < pb
      end
      return a._i < b._i
    end)
    for _, cap in ipairs(caps) do
      if not cap.capture:find("^_") and cap.capture ~= "spell" and cap.capture ~= "nospell" then
        local f, b, found, nocombine = hl_fallback("@" .. cap.capture .. "." .. cap.lang)
        if found then
          -- Neovim combines stacked captures: fg is replaced, bold is OR-ed,
          -- unless the higher group is `nocombine`
          fg, name = f or fg, "@" .. cap.capture
          bold = nocombine and b or (bold or b)
        end
      end
    end
  else
    local id = vim.fn.synID(row + 1, col + 1, 1)
    if id > 0 then
      name = vim.fn.synIDattr(id, "name")
      fg, bold = hl(vim.fn.synIDattr(vim.fn.synIDtrans(id), "name"))
    end
  end
  return fg or normal, bold, name
end

for row = first - 1, math.min(last, vim.api.nvim_buf_line_count(0)) - 1 do
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]
  local disp, runs, cur = 0, {}, nil
  for i = 1, #line do
    local ch = line:sub(i, i)
    local w = ch == "\t" and (8 - disp % 8) or 1
    if ch:match("%s") then
      cur = nil
    else
      local fg, bold, name = style_at(row, i - 1)
      if cur and cur.fg == fg and cur.bold == bold and cur.name == name then
        cur.text = cur.text .. ch
        cur.len = cur.len + 1
      else
        cur = { line = row + 1, col = disp, len = 1, text = ch, fg = fg, bold = bold, name = name }
        runs[#runs + 1] = cur
      end
    end
    -- multi-byte chars: count display cells once per char start
    if ch:byte() < 0x80 or ch:byte() >= 0xC0 then
      disp = disp + w
    end
  end
  for _, r in ipairs(runs) do
    io.stdout:write(vim.json.encode(r), "\n")
  end
end
