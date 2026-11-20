-- Treesitter captures for tanuki-day (GitLab "Light" syntax theme).
-- GitLab's light theme marks structure with weight as much as color: keywords are
-- bold text color, types bold slate, function names bold dark red.
-- Per-language deviations live in groups/languages_day.lua.
return function(c, o)
  local s = o.styles
  local kw = vim.tbl_extend("force", { fg = c.syn_keyword, bold = true }, s.keywords)
  local func = vim.tbl_extend("force", { fg = c.syn_func, bold = true }, s.functions)
  local ty = { fg = c.syn_type, bold = true }
  local str = vim.tbl_extend("force", { fg = c.syn_string }, s.strings)
  return {
    -- identifiers
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.syn_builtin, bold = true }, -- this / self
    ["@variable.parameter"] = { fg = c.syn_builtin }, -- hljs-params
    ["@variable.parameter.builtin"] = { fg = c.syn_builtin },
    ["@variable.member"] = { fg = c.syn_teal }, -- obj.prop (hljs-property)

    ["@constant"] = { fg = c.syn_teal }, -- SCREAMING_CASE (variable.constant)
    ["@constant.builtin"] = { fg = c.syn_builtin }, -- true false nil null (hljs-literal)
    ["@constant.macro"] = { fg = c.fg },

    ["@module"] = { fg = c.fg },
    ["@module.builtin"] = { fg = c.fg },
    ["@label"] = { fg = c.fg },

    -- literals
    ["@string"] = "String",
    ["@string.documentation"] = "String",
    ["@string.regexp"] = { fg = c.syn_regex },
    ["@string.escape"] = str,
    ["@string.special"] = str,
    ["@string.special.symbol"] = { fg = c.syn_symbol }, -- ruby :sym
    ["@string.special.path"] = str,
    ["@string.special.url"] = { fg = c.syn_string, underline = true },
    ["@character"] = "Character",
    ["@character.special"] = str,
    ["@boolean"] = { fg = c.syn_builtin },
    ["@number"] = "Number",
    ["@number.float"] = "Number",

    -- types
    ["@type"] = ty,
    ["@type.builtin"] = ty,
    ["@type.definition"] = ty,
    ["@attribute"] = { fg = c.syn_preproc, bold = true }, -- decorators (hljs-meta)
    ["@attribute.builtin"] = { fg = c.syn_preproc, bold = true },
    ["@property"] = { fg = c.syn_teal }, -- keys (hljs-attr / hljs-property)

    -- functions
    ["@function"] = "Function",
    ["@function.builtin"] = ty, -- hljs-built_in
    ["@function.call"] = func,
    ["@function.macro"] = { fg = c.fg },
    ["@function.method"] = "Function",
    ["@function.method.call"] = func,
    ["@constructor"] = ty,
    ["@operator"] = { fg = c.fg },

    -- keywords
    ["@keyword"] = kw,
    ["@keyword.coroutine"] = kw,
    ["@keyword.function"] = kw,
    ["@keyword.operator"] = kw,
    ["@keyword.import"] = kw,
    ["@keyword.type"] = kw,
    ["@keyword.modifier"] = kw,
    ["@keyword.repeat"] = kw,
    ["@keyword.return"] = kw,
    ["@keyword.debug"] = kw,
    ["@keyword.exception"] = kw,
    ["@keyword.conditional"] = kw,
    ["@keyword.conditional.ternary"] = { fg = c.fg },
    ["@keyword.directive"] = { fg = c.syn_preproc, bold = true },
    ["@keyword.directive.define"] = { fg = c.syn_preproc, bold = true },

    -- punctuation
    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.special"] = { fg = c.fg },

    -- comments
    ["@comment"] = "Comment",
    ["@comment.documentation"] = "Comment",
    ["@comment.error"] = { fg = c.red, bold = true },
    ["@comment.warning"] = { fg = c.orange, bold = true },
    ["@comment.todo"] = { fg = c.comment, bold = true, italic = true },
    ["@comment.note"] = { fg = c.comment, bold = true, italic = true },

    -- markup (markdown etc.)
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = c.syn_heading, bold = true },
    ["@markup.heading.marker"] = { fg = c.syn_heading, bold = true },
    ["@markup.quote"] = { fg = c.syn_quote },
    ["@markup.math"] = { fg = c.syn_teal },
    ["@markup.link"] = { fg = c.fg },
    ["@markup.link.label"] = { fg = c.syn_string },
    ["@markup.link.url"] = { fg = c.syn_string, underline = true },
    ["@markup.raw"] = { fg = c.syn_string },
    ["@markup.raw.block"] = { fg = c.fg },
    ["@markup.list"] = { fg = c.syn_teal },
    ["@markup.list.checked"] = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.comment },

    ["@diff.plus"] = "Added",
    ["@diff.minus"] = "Removed",
    ["@diff.delta"] = "Changed",

    -- tags (HTML/JSX/Vue)
    ["@tag"] = { fg = c.fg }, -- hljs-name has no color in GitLab's light theme
    ["@tag.builtin"] = { fg = c.fg },
    ["@tag.attribute"] = { fg = c.syn_teal },
    ["@tag.delimiter"] = { fg = c.fg },

    -- tanuki-day only captures (queries/*/highlights.scm); undefined in tanuki-night.
    -- nocombine: they replace what lower captures set (bold included), not add to it.
    ["@tanuki.preproc"] = { fg = c.syn_preproc, bold = true, nocombine = true }, -- hljs-meta: #define line
    ["@tanuki.title"] = { fg = c.syn_func, bold = true, nocombine = true }, -- struct names, `function a.b()`
    ["@tanuki.builtin"] = { fg = c.syn_type, bold = true, nocombine = true }, -- libc / lua stdlib names
    ["@tanuki.params"] = { fg = c.syn_builtin, nocombine = true }, -- hljs-params: go receiver
    ["@tanuki.plain"] = { fg = c.fg, nocombine = true },
    ["@tanuki.section"] = { fg = c.syn_heading, bold = true, nocombine = true }, -- make rule lines
    ["@tanuki.var"] = { fg = c.syn_teal, nocombine = true }, -- $(VAR), typed TS params
    ["@tanuki.string"] = { fg = c.syn_string, nocombine = true },
    ["@tanuki.keyword"] = { fg = c.syn_keyword, bold = true, nocombine = true },
    ["@tanuki.call"] = { fg = c.syn_type, nocombine = true }, -- c++ calls, JS/TS class refs
    ["@tanuki.class"] = { fg = c.syn_type, bold = true, nocombine = true },
    ["@tanuki.blue"] = { fg = c.syn_builtin, nocombine = true },
    ["@tanuki.attribute"] = { fg = c.syn_preproc, bold = true, nocombine = true }, -- rust #[...]

    ["@none"] = {},
  }
end
