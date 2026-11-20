-- Legacy Vim syntax groups (also the fallback for Treesitter captures).
return function(c, o)
  local s = o.styles
  return {
    Comment = vim.tbl_extend("force", { fg = c.comment }, s.comments),
    SpecialComment = "Comment",
    Todo = { fg = c.comment, bold = true },

    Constant = { fg = c.red },
    String = vim.tbl_extend("force", { fg = c.green }, s.strings),
    Character = { fg = c.green },
    Number = { fg = c.orange },
    Float = "Number",
    Boolean = { fg = c.purple },

    Identifier = { fg = c.fg },
    Function = vim.tbl_extend("force", { fg = c.blue }, s.functions),

    Statement = vim.tbl_extend("force", { fg = c.purple }, s.keywords),
    Conditional = "Statement",
    Repeat = "Statement",
    Label = "Statement",
    Keyword = "Statement",
    Exception = "Statement",
    Operator = { fg = c.fg },

    PreProc = { fg = c.purple },
    Include = "PreProc",
    Define = "PreProc",
    PreCondit = "PreProc",
    Macro = { fg = c.fg },

    Type = { fg = c.yellow },
    StorageClass = { fg = c.yellow },
    Structure = { fg = c.purple },
    Typedef = { fg = c.purple },

    Special = { fg = c.aqua },
    SpecialChar = { fg = c.green },
    Tag = { fg = c.fg },
    Delimiter = { fg = c.fg },
    Debug = { fg = c.red },

    Underlined = { fg = c.blue, underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = c.nontext },
    Error = { fg = c.red },
  }
end
