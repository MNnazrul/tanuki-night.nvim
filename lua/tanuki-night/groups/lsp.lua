-- LSP semantic tokens.
-- GitLab's look comes from a syntax highlighter, not from semantic analysis, so most
-- semantic token types are cleared and Treesitter colors stay visible. Only tokens
-- that add information Treesitter can't know are kept.
local cleared = {
  "class",
  "comment",
  "decorator",
  "enum",
  "enumMember",
  "event",
  "function",
  "interface",
  "keyword",
  "macro",
  "method",
  "modifier",
  "namespace",
  "number",
  "operator",
  "parameter",
  "property",
  "regexp",
  "string",
  "struct",
  "type",
  "typeParameter",
  "variable",
}

return function(c)
  local hl = {}
  for _, t in ipairs(cleared) do
    hl["@lsp.type." .. t] = {}
  end

  hl["@lsp.mod.deprecated"] = { strikethrough = true }
  hl["@lsp.type.unresolvedReference"] = { undercurl = true, sp = c.red }
  hl["@lsp.typemod.function.defaultLibrary"] = { fg = c.fg }
  hl["@lsp.typemod.variable.defaultLibrary"] = { fg = c.fg }
  hl["@lsp.type.selfKeyword.rust"] = { fg = c.red }
  hl["@lsp.typemod.struct.declaration.rust"] = { fg = c.yellow }
  hl["@lsp.typemod.enum.declaration.rust"] = { fg = c.yellow }
  hl["@lsp.type.builtinType.rust"] = { fg = c.yellow }

  return hl
end
