-- :checkhealth tanuki-night
local M = {}

-- Neovim 0.9 only has the report_* names
local health = {
  start = vim.health.start or vim.health.report_start,
  ok = vim.health.ok or vim.health.report_ok,
  info = vim.health.info or vim.health.report_info,
  warn = vim.health.warn or vim.health.report_warn,
  error = vim.health.error or vim.health.report_error,
}

-- Languages with GitLab rules (README "Features"). Parser name = Treesitter language.
M.languages = {
  "bash",
  "c",
  "cpp",
  "css",
  "go",
  "html",
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "python",
  "ruby",
  "rust",
  "scss",
  "toml",
  "tsx",
  "typescript",
  "vue",
  "yaml",
  "zig",
}

local function has_parser(lang)
  local ok = pcall(vim.treesitter.language.add, lang)
  return ok and #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0
end

-- Options whose default is nil, so they're missing from config.defaults.
local nil_defaults = { style = true, on_colors = true, on_highlights = true }

--- Option names in `opts` that tanuki-night doesn't know (catches typos like "transparant").
function M.unknown_options(opts, defaults)
  local unknown = {}
  for key, value in pairs(opts or {}) do
    if defaults[key] == nil and not nil_defaults[key] then
      unknown[#unknown + 1] = tostring(key)
    elseif key == "styles" and type(value) == "table" then
      -- styles.<group> holds any nvim_set_hl() attributes, so only the group names are checked
      for group in pairs(value) do
        if defaults.styles[group] == nil then
          unknown[#unknown + 1] = "styles." .. tostring(group)
        end
      end
    end
  end
  table.sort(unknown)
  return unknown
end

local function check_neovim()
  health.start("Neovim")
  if vim.fn.has("nvim-0.9") == 1 then
    local v = vim.version()
    health.ok(("Neovim %d.%d.%d"):format(v.major, v.minor, v.patch))
  else
    health.error("Neovim 0.9 or newer is required")
  end

  local name = vim.g.colors_name
  if name == "tanuki-night" or name == "tanuki-day" then
    health.ok("Active colorscheme: " .. name)
  else
    health.info(
      ("Active colorscheme is %s, not tanuki-night or tanuki-day"):format(name and ("'" .. name .. "'") or "not set")
    )
  end
end

local function check_colors()
  health.start("Colors")
  if vim.o.termguicolors then
    health.ok("'termguicolors' is on")
  else
    health.warn("'termguicolors' is off, so 24-bit colors aren't used", {
      "Loading the colorscheme turns it on. If it's off now, something set it afterwards.",
      "Add `vim.o.termguicolors = true` to your config.",
    })
  end

  local colorterm = (vim.env.COLORTERM or ""):lower()
  if colorterm == "truecolor" or colorterm == "24bit" then
    health.ok("Terminal reports truecolor support ($COLORTERM=" .. colorterm .. ")")
  elseif vim.fn.has("gui_running") == 1 then
    health.ok("Running in a GUI")
  else
    health.warn("$COLORTERM isn't 'truecolor', so the terminal may not show 24-bit colors", {
      "Most modern terminals (kitty, Ghostty, WezTerm, Alacritty, iTerm2) support truecolor but don't always say so.",
      "In tmux, add `set -as terminal-features ',*:RGB'` to tmux.conf.",
      "If colors look wrong or washed out, check your terminal's truecolor support.",
    })
  end
end

local function check_config()
  health.start("Configuration")
  local config = require("tanuki-night.config")
  local unknown = M.unknown_options(config.options, config.defaults)
  if #unknown == 0 then
    health.ok("setup() options are valid")
  else
    health.warn("Unknown setup() options: " .. table.concat(unknown, ", "), {
      "Check for typos. Valid options are listed in :help tanuki-night-config",
    })
  end
end

local function check_treesitter()
  health.start("Treesitter")
  local installed, missing, broken = {}, {}, {}

  for _, lang in ipairs(M.languages) do
    if has_parser(lang) then
      installed[#installed + 1] = lang
      -- an outdated parser can't compile newer queries, which breaks highlighting for the language
      local ok, err = pcall(vim.treesitter.query.get, lang, "highlights")
      if not ok then
        broken[#broken + 1] = { lang = lang, err = tostring(err):gsub("^.-:%d+: ", "") }
      end
    else
      missing[#missing + 1] = lang
    end
  end

  if #installed > 0 then
    health.ok("Parsers installed: " .. table.concat(installed, ", "))
  end
  if #missing > 0 then
    -- health.info() takes no advice, so the hint goes in the message
    health.info(
      ("No parser for: %s. Only needed if you edit these languages: without a parser, Vim's regex syntax is used and GitLab's per-language rules don't apply. Install one with e.g. `:TSInstall %s` (nvim-treesitter)."):format(
        table.concat(missing, ", "),
        missing[1]
      )
    )
  end
  for _, b in ipairs(broken) do
    health.error(("Highlight query for %s doesn't compile: %s"):format(b.lang, b.err), {
      "Highlighting for " .. b.lang .. " is broken until this is fixed.",
      "The parser is probably older than the queries. Update it with `:TSUpdate " .. b.lang .. "`.",
    })
  end
  if #installed > 0 and #broken == 0 then
    health.ok("Highlight queries compile for every installed parser")
  end
end

function M.check()
  check_neovim()
  check_colors()
  check_config()
  check_treesitter()
end

return M
