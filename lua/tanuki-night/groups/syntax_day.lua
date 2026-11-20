-- Legacy Vim syntax groups for tanuki-day (GitLab "Light" syntax theme).
return function(c, o)
  local s = o.styles
  return {
    Comment = vim.tbl_extend("force", { fg = c.comment, italic = true }, s.comments),
    SpecialComment = "Comment",
    Todo = { fg = c.comment, bold = true, italic = true },

    Constant = { fg = c.syn_teal },
    String = vim.tbl_extend("force", { fg = c.syn_string }, s.strings),
    Character = { fg = c.syn_string },
    Number = { fg = c.syn_number },
    Float = "Number",
    Boolean = { fg = c.syn_builtin },

    Identifier = { fg = c.fg },
    Function = vim.tbl_extend("force", { fg = c.syn_func, bold = true }, s.functions),

    Statement = vim.tbl_extend("force", { fg = c.syn_keyword, bold = true }, s.keywords),
    Conditional = "Statement",
    Repeat = "Statement",
    Label = "Statement",
    Keyword = "Statement",
    Exception = "Statement",
    Operator = { fg = c.fg },

    PreProc = { fg = c.syn_preproc, bold = true },
    Include = "PreProc",
    Define = "PreProc",
    PreCondit = "PreProc",
    Macro = { fg = c.fg },

    Type = { fg = c.syn_type, bold = true },
    StorageClass = { fg = c.syn_type, bold = true },
    Structure = "Statement",
    Typedef = "Statement",

    Special = { fg = c.syn_teal },
    SpecialChar = { fg = c.syn_string },
    Tag = { fg = c.syn_tag },
    Delimiter = { fg = c.fg },
    Debug = { fg = c.red },

    Underlined = { fg = c.blue, underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = c.nontext },
    Error = { fg = c.red },
  }
end
