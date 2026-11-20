-- Per-language overrides for tanuki-day, matched token by token against GitLab light
-- screenshots (images/light/) with scripts/compare_light.py.
-- GitLab highlights some languages with highlight.js and some with Rouge, so the rules
-- differ a lot between languages.
return function(c)
  local fg = { fg = c.fg }
  local ty = { fg = c.syn_type, bold = true }
  local teal = { fg = c.syn_teal }
  local blue = { fg = c.syn_builtin }
  local grey = { fg = c.syn_preproc }
  local str = { fg = c.syn_string }
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

  -- C: `static const unsigned int` are types (bold slate), #include is meta,
  -- calls plain (libc built-ins slate via queries/c), params blue.
  add(lang("c", {
    ["@keyword.modifier"] = ty,
    ["@keyword.import"] = { fg = c.syn_preproc, bold = true },
    ["@constant"] = fg,
    ["@constant.macro"] = fg,
    ["@function.call"] = fg,
    ["@variable.member"] = fg,
    ["@property"] = fg,
  }))

  -- C++: user types plain, every call slate, params plain.
  add(lang("cpp", {
    ["@keyword.modifier"] = ty,
    ["@keyword.import"] = { fg = c.syn_preproc, bold = true },
    ["@constant"] = fg,
    ["@constant.macro"] = fg,
    ["@type"] = fg,
    ["@type.definition"] = fg,
    ["@type.builtin"] = ty,
    ["@function.call"] = { fg = c.syn_type },
    ["@function.method.call"] = { fg = c.syn_type },
    ["@constructor"] = { fg = c.syn_type },
    ["@variable.member"] = fg,
    ["@property"] = fg,
    ["@module"] = fg,
  }))

  -- Go: user types and constants plain, calls plain; func names dark red, params blue
  -- (methods: only the receiver, see queries/go).
  add(lang("go", {
    ["@type"] = fg,
    ["@type.definition"] = fg,
    ["@constant"] = fg,
    ["@function.call"] = fg,
    ["@function.method.call"] = fg,
    ["@variable.member"] = fg,
    ["@property"] = fg,
  }))

  -- Python (Rouge): built-ins blue, None/True/False grey, decorators plain,
  -- imported/used class names plain (definitions bold slate), calls plain.
  add(lang("python", {
    ["@variable.parameter"] = fg,
    ["@variable.builtin"] = fg,
    ["@variable.member"] = fg,
    ["@property"] = fg,
    ["@type"] = fg,
    ["@type.builtin"] = blue,
    ["@function.builtin"] = blue,
    ["@function.call"] = fg,
    ["@constant.builtin"] = grey,
    ["@boolean"] = grey,
    ["@constant"] = fg,
    ["@attribute"] = fg,
    ["@attribute.builtin"] = fg,
  }))

  -- Lua: calls plain, field functions plain (`function a.b()` titles and stdlib
  -- names come from queries/lua), params blue.
  add(lang("lua", {
    ["@constructor"] = fg, -- table constructor {}
    ["@function"] = fg,
    ["@function.call"] = fg,
    ["@function.method.call"] = fg,
    ["@module.builtin"] = fg,
    ["@variable.member"] = fg,
    ["@property"] = fg,
    ["@constant"] = fg,
  }))
  -- luadoc annotations stay comment grey
  add(lang("luadoc", {
    ["@keyword"] = { fg = c.comment, italic = true },
    ["@keyword.import"] = { fg = c.comment, italic = true },
    ["@type"] = { fg = c.comment, italic = true },
    ["@type.builtin"] = { fg = c.comment, italic = true },
    ["@variable"] = { fg = c.comment, italic = true },
    ["@variable.parameter"] = { fg = c.comment, italic = true },
    ["@punctuation.bracket"] = { fg = c.comment, italic = true },
    ["@punctuation.special"] = { fg = c.comment, italic = true },
    ["@operator"] = { fg = c.comment, italic = true },
  }))

  -- JavaScript / TypeScript: .prop teal, SCREAMING_CASE teal, params blue
  -- (typed TS params teal via queries/typescript); jsdoc tags.
  for _, l in ipairs({ "javascript", "typescript", "tsx" }) do
    add(lang(l, { ["@character.special"] = fg })) -- import * as x
  end
  add(lang("jsdoc", {
    ["@keyword"] = fg,
    ["@type"] = ty,
    ["@variable"] = teal,
    ["@variable.parameter"] = teal,
  }))

  -- Vue template: tags plain, attributes teal, directive values red (queries/vue).
  add(lang("vue", {
    ["@tag"] = { fg = c.syn_tag },
    ["@function.method"] = teal,
    ["@constant"] = fg,
    ["@variable.builtin"] = fg,
  }))

  -- Ruby: calls and built-ins (include, has_many) plain.
  add(lang("ruby", {
    ["@function.call"] = fg,
    ["@function.method.call"] = fg,
    ["@function.builtin"] = fg,
  }))

  -- Rust (Rouge): types/consts/calls plain, `let` names teal, self/Some plain.
  add(lang("rust", {
    ["@type"] = fg,
    ["@constant"] = fg,
    ["@constructor"] = fg,
    ["@function.call"] = fg,
    ["@function.method.call"] = fg,
    ["@function.macro"] = fg,
    ["@variable.builtin"] = fg,
    ["@variable.parameter"] = fg,
    ["@variable.let"] = teal,
    ["@variable.member"] = fg,
    ["@property"] = fg,
    ["@attribute"] = { fg = c.syn_preproc, bold = true },
    ["@attribute.builtin"] = { fg = c.syn_preproc, bold = true },
  }))

  -- Zig (Rouge): definitions and plain calls plain, `std.x.call()` dark red
  -- (queries/zig), @builtins blue.
  add(lang("zig", {
    ["@function"] = fg,
    ["@function.call"] = fg,
    ["@function.builtin"] = blue,
    ["@variable.parameter"] = fg,
    ["@variable.member"] = fg,
    ["@constant"] = fg,
    ["@type"] = fg,
    ["@boolean"] = fg,
  }))

  -- Bash: $vars and assignments teal, commands plain, hljs built-ins blue, numbers plain.
  add(lang("bash", {
    ["@variable"] = teal,
    ["@variable.parameter"] = fg,
    ["@function"] = fg,
    ["@function.call"] = fg,
    ["@function.builtin"] = fg, -- built-ins come from queries/bash (hljs list)
    ["@constant"] = teal,
    ["@number"] = fg,
    ["@keyword.directive"] = { fg = c.comment, italic = true },
  }))

  -- CSS / SCSS: $vars teal, selectors/properties/values/numbers plain.
  for _, l in ipairs({ "css", "scss", "less" }) do
    add(lang(l, {
      ["@variable"] = teal,
      ["@property"] = fg,
      ["@type"] = fg,
      ["@attribute"] = fg,
      ["@number"] = fg,
      ["@number.float"] = fg,
      ["@string"] = fg,
      ["@string.special"] = fg,
      ["@tag"] = fg,
      ["@function"] = fg,
      ["@keyword.directive"] = { fg = c.syn_keyword, bold = true },
    }))
  end

  -- HTML: tags plain, attributes teal, <title> text plain, doctype meta.
  add(lang("html", {
    ["@markup.heading"] = fg,
    ["@markup.heading.1"] = fg,
    ["@markup.raw"] = fg,
    ["@constant"] = { fg = c.syn_preproc, bold = true },
    ["@keyword.directive"] = { fg = c.syn_preproc, bold = true },
  }))

  -- Makefile: recipe commands/args plain, assignments plain, $(VAR) teal,
  -- rule lines purple bold (queries/make).
  add(lang("make", {
    ["@function.call"] = fg,
    ["@function.builtin"] = { fg = c.syn_preproc, bold = true },
    ["@variable.parameter"] = fg,
    ["@string"] = teal,
    ["@string.special.symbol"] = fg,
    ["@string.special.path"] = fg,
    ["@variable"] = teal,
  }))

  -- TOML: keys plain.
  add(lang("toml", { ["@property"] = fg }))

  -- Markdown: link text and URL red.
  add(lang("markdown_inline", { ["@markup.link"] = str }))

  return hl
end
