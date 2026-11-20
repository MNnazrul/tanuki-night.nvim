-- Per-language overrides, matched to GitLab screenshots (images/, images/round2/).
return function(c)
  local fg = { fg = c.fg }
  local function lang(l, groups)
    local out = {}
    for cap, spec in pairs(groups) do
      out[cap .. "." .. l] = spec
    end
    return out
  end

  local hl = {}
  local function add(t)
    for k, v in pairs(t) do
      hl[k] = v
    end
  end

  -- C: `static const unsigned` yellow, `struct/typedef/enum` purple, defs + params blue.
  local c_like = {
    ["@keyword.modifier"] = { fg = c.yellow },
    ["@keyword.type"] = { fg = c.purple },
    ["@constant"] = fg,
    ["@constant.macro"] = fg,
  }
  add(lang("c", c_like))
  -- C++ (inkscape.cpp): function definitions plain, rest like C.
  add(lang(
    "cpp",
    vim.tbl_extend("force", c_like, {
      ["@function"] = fg,
      ["@function.method"] = fg,
      ["@function.method.call"] = fg,
      ["@module"] = fg,
    })
  ))

  -- Rust: params plain, type usage plain (decls + prelude yellow via queries/rust),
  -- attributes grey, `self`/`Some` red, `let` bindings red.
  add(lang("rust", {
    ["@variable.parameter"] = fg,
    ["@type"] = fg,
    ["@type.definition"] = { fg = c.yellow },
    ["@attribute"] = { fg = c.comment },
    ["@attribute.builtin"] = { fg = c.comment },
    ["@constant"] = fg,
    ["@constructor"] = fg,
    ["@function.method.call"] = fg,
    ["@variable.let"] = { fg = c.red },
  }))

  -- Rust via rust.vim regex syntax (when no Treesitter parser is installed).
  add({
    rustAttribute = { fg = c.comment },
    rustDerive = { fg = c.comment },
    rustDeriveTrait = { fg = c.comment },
    rustStorage = { fg = c.purple }, -- mut ref
    rustSigil = fg,
    rustSelf = { fg = c.red },
    rustFuncCall = fg,
    rustModPath = fg,
    rustModPathSep = fg,
    rustIdentifier = { fg = c.yellow }, -- struct/enum names
    rustMacro = fg,
    rustEnumVariant = { fg = c.red },
    rustLifetime = { fg = c.purple },
  })

  -- Zig: operators aqua, method calls blue, decl names plain.
  add(lang("zig", {
    ["@operator"] = { fg = c.aqua },
    ["@function"] = fg,
    ["@function.builtin"] = fg,
    ["@keyword.modifier"] = { fg = c.purple },
  }))

  -- Python: def names plain, method calls blue, self/cls plain, decorators aqua.
  add(lang("python", {
    ["@function"] = fg,
    ["@function.method"] = fg,
    ["@variable.builtin"] = fg,
    ["@variable.parameter"] = fg,
    ["@constructor"] = fg,
    ["@constant"] = fg,
  }))

  -- Lua: function names plain, params blue.
  add(lang("lua", {
    ["@function"] = fg,
    ["@function.method"] = fg,
    ["@function.method.call"] = fg,
    ["@constant"] = fg,
    ["@constructor"] = fg, -- table constructor {}
  }))

  -- Go: builtin types yellow, user types/funcs plain, params blue.
  add(lang("go", {
    ["@type"] = fg,
    ["@type.definition"] = fg,
    ["@function"] = fg,
    ["@function.method"] = fg,
    ["@function.method.call"] = fg,
    ["@constant"] = fg,
    ["@module"] = fg,
  }))

  -- JS / TS / Vue: `this` purple, SCREAMING_CASE red, PascalCase yellow.
  for _, l in ipairs({ "javascript", "typescript", "tsx", "jsx", "vue" }) do
    add(lang(l, {
      ["@variable.builtin"] = { fg = c.purple },
      ["@variable.parameter"] = fg,
      ["@function"] = fg,
      ["@function.method"] = fg,
      ["@character.special"] = fg, -- import * as x
    }))
  end

  -- Ruby: symbols + hash keys green, ClassNames yellow.
  add(lang("ruby", {
    ["@function"] = fg,
    ["@function.method"] = fg,
    ["@function.method.call"] = fg,
    ["@variable.parameter"] = fg,
    ["@variable.member"] = { fg = c.red },
    ["@property"] = { fg = c.green },
  }))

  -- Shell: all variables red, commands plain, shebang grey, bare numbers plain.
  add(lang("bash", {
    ["@variable"] = { fg = c.red },
    ["@variable.parameter"] = fg,
    ["@function"] = fg,
    ["@function.call"] = fg,
    ["@function.builtin"] = fg,
    ["@constant"] = { fg = c.red },
    ["@number"] = fg,
    ["@keyword.directive"] = { fg = c.comment },
  }))

  -- SCSS / CSS: $vars red, .class yellow, :pseudo aqua, properties/values plain.
  for _, l in ipairs({ "css", "scss", "less" }) do
    add(lang(l, {
      ["@variable"] = { fg = c.red },
      ["@property"] = fg,
      ["@type"] = { fg = c.yellow },
      ["@attribute"] = { fg = c.aqua },
      ["@number"] = fg,
      ["@number.float"] = fg,
      ["@string.special"] = fg,
      ["@tag"] = fg,
      ["@keyword.directive"] = { fg = c.purple },
      ["@function"] = fg,
    }))
  end

  -- YAML: keys blue, values green.
  add(lang("yaml", {
    ["@property"] = { fg = c.blue },
    ["@variable"] = { fg = c.green },
  }))

  -- TOML: [sections] and keys plain.
  add(lang("toml", {
    ["@type"] = fg,
    ["@property"] = fg,
  }))

  -- JSON: keys plain.
  add(lang("json", { ["@property"] = fg }))
  add(lang("jsonc", { ["@property"] = fg }))

  -- Makefile: targets green, $(VAR) red, .PHONY purple.
  add(lang("make", {
    ["@function"] = { fg = c.green },
    ["@variable"] = { fg = c.red },
    ["@variable.builtin"] = { fg = c.red },
    ["@string.special.symbol"] = { fg = c.green },
  }))

  -- HTML / Vue templates: tags plain, attributes blue, values green.
  add(lang("html", {
    ["@tag"] = fg,
    ["@tag.attribute"] = { fg = c.blue },
    ["@keyword.directive"] = { fg = c.purple },
  }))

  return hl
end
