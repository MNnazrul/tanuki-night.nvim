-- Treesitter captures. Defaults follow the majority look across GitLab screenshots;
-- per-language deviations live in groups/languages.lua.
return function(c, o)
  local s = o.styles
  local kw = vim.tbl_extend("force", { fg = c.purple }, s.keywords)
  return {
    -- identifiers
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.red }, -- self (rust), $@ ...
    ["@variable.parameter"] = { fg = c.blue }, -- C/C++/Lua/Go params
    ["@variable.parameter.builtin"] = { fg = c.red },
    ["@variable.member"] = { fg = c.fg },

    ["@constant"] = { fg = c.red }, -- SCREAMING_CASE (TS/JS)
    ["@constant.builtin"] = { fg = c.purple }, -- true false nil null NULL
    ["@constant.macro"] = { fg = c.fg },

    ["@module"] = { fg = c.fg },
    ["@module.builtin"] = { fg = c.fg },
    ["@label"] = { fg = c.purple },

    -- literals
    ["@string"] = "String",
    ["@string.documentation"] = "String",
    ["@string.regexp"] = { fg = c.green },
    ["@string.escape"] = { fg = c.green },
    ["@string.special"] = { fg = c.green },
    ["@string.special.symbol"] = { fg = c.green }, -- ruby :sym
    ["@string.special.path"] = { fg = c.green },
    ["@string.special.url"] = { fg = c.orange, underline = true },
    ["@character"] = "Character",
    ["@character.special"] = { fg = c.green },
    ["@boolean"] = { fg = c.purple },
    ["@number"] = "Number",
    ["@number.float"] = "Number",

    -- types
    ["@type"] = { fg = c.yellow },
    ["@type.builtin"] = { fg = c.yellow },
    ["@type.definition"] = { fg = c.yellow },
    ["@attribute"] = { fg = c.aqua }, -- python @decorator
    ["@attribute.builtin"] = { fg = c.aqua },
    ["@property"] = { fg = c.fg },

    -- functions
    ["@function"] = "Function",
    ["@function.builtin"] = { fg = c.fg },
    ["@function.call"] = { fg = c.fg },
    ["@function.macro"] = { fg = c.fg },
    ["@function.method"] = "Function",
    ["@function.method.call"] = { fg = c.blue }, -- obj.method() (python, zig)
    ["@constructor"] = { fg = c.yellow },
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
    ["@keyword.directive"] = { fg = c.purple },
    ["@keyword.directive.define"] = { fg = c.purple },

    -- punctuation
    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.special"] = { fg = c.fg },

    -- comments
    ["@comment"] = "Comment",
    ["@comment.documentation"] = "Comment",
    ["@comment.error"] = { fg = c.red, bold = true },
    ["@comment.warning"] = { fg = c.orange, bold = true },
    ["@comment.todo"] = { fg = c.comment, bold = true },
    ["@comment.note"] = { fg = c.comment, bold = true },

    -- markup (markdown etc.)
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = c.green, bold = true },
    ["@markup.heading.marker"] = { fg = c.green },
    ["@markup.quote"] = { fg = c.comment, italic = true },
    ["@markup.math"] = { fg = c.aqua },
    ["@markup.link"] = { fg = c.fg },
    ["@markup.link.label"] = { fg = c.green },
    ["@markup.link.url"] = { fg = c.orange, underline = true },
    ["@markup.raw"] = { fg = c.green },
    ["@markup.raw.block"] = { fg = c.fg },
    ["@markup.list"] = { fg = c.red },
    ["@markup.list.checked"] = { fg = c.green },
    ["@markup.list.unchecked"] = { fg = c.comment },

    ["@diff.plus"] = "Added",
    ["@diff.minus"] = "Removed",
    ["@diff.delta"] = "Changed",

    -- tags (HTML/JSX/Vue)
    ["@tag"] = { fg = c.fg },
    ["@tag.builtin"] = { fg = c.fg },
    ["@tag.attribute"] = { fg = c.blue },
    ["@tag.delimiter"] = { fg = c.fg },

    ["@none"] = {},
  }
end
