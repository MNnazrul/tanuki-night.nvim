local util = require("tanuki-night.util")

return function(c, o)
  local bg = o.transparent and "NONE" or c.bg
  return {
    -- gitsigns
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.blue },
    GitSignsDelete = { fg = c.red },
    GitSignsAddLn = { bg = c.diff_add },
    GitSignsChangeLn = { bg = c.diff_change },
    GitSignsDeleteLn = { bg = c.diff_delete },
    GitSignsAddInline = { bg = c.diff_add_text },
    GitSignsChangeInline = { bg = c.diff_add_text },
    GitSignsDeleteInline = { bg = c.diff_delete_text },
    GitSignsAddPreview = { fg = c.green, bg = c.diff_add },
    GitSignsDeletePreview = { fg = c.red, bg = c.diff_delete },
    GitSignsDeleteVirtLn = { fg = c.red, bg = c.diff_delete },
    GitSignsCurrentLineBlame = { fg = c.line_nr },

    -- telescope
    TelescopeNormal = { fg = c.fg, bg = c.bg_alt },
    TelescopeBorder = { fg = c.bg_alt, bg = c.bg_alt },
    TelescopePromptNormal = { fg = c.fg, bg = c.bg_hl },
    TelescopePromptBorder = { fg = c.bg_hl, bg = c.bg_hl },
    TelescopePromptTitle = { fg = c.bg, bg = c.accent, bold = true },
    TelescopePromptPrefix = { fg = c.accent, bg = c.bg_hl },
    TelescopeResultsTitle = { fg = c.bg_alt, bg = c.bg_alt },
    TelescopePreviewTitle = { fg = c.bg, bg = c.green, bold = true },
    TelescopeSelection = { bg = c.bg_hl, bold = true },
    TelescopeSelectionCaret = { fg = c.accent, bg = c.bg_hl },
    TelescopeMatching = { fg = c.accent, bold = true },

    -- fzf-lua
    FzfLuaNormal = "NormalFloat",
    FzfLuaBorder = "FloatBorder",
    FzfLuaTitle = "FloatTitle",
    FzfLuaCursorLine = "PmenuSel",

    -- nvim-cmp
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrDeprecated = { fg = c.comment, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.accent, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.accent, bold = true },
    CmpItemMenu = { fg = c.comment },
    CmpItemKindDefault = { fg = c.fg },
    CmpItemKindText = { fg = c.fg },
    CmpItemKindKeyword = { fg = c.purple },
    CmpItemKindFunction = { fg = c.blue },
    CmpItemKindMethod = { fg = c.blue },
    CmpItemKindConstructor = { fg = c.yellow },
    CmpItemKindVariable = { fg = c.red },
    CmpItemKindField = { fg = c.fg },
    CmpItemKindProperty = { fg = c.fg },
    CmpItemKindClass = { fg = c.yellow },
    CmpItemKindStruct = { fg = c.yellow },
    CmpItemKindInterface = { fg = c.yellow },
    CmpItemKindEnum = { fg = c.yellow },
    CmpItemKindEnumMember = { fg = c.aqua },
    CmpItemKindModule = { fg = c.purple },
    CmpItemKindConstant = { fg = c.orange },
    CmpItemKindSnippet = { fg = c.green },
    CmpItemKindFile = { fg = c.blue },
    CmpItemKindFolder = { fg = c.blue },
    CmpItemKindTypeParameter = { fg = c.yellow },
    CmpItemKindCopilot = { fg = c.aqua },

    -- blink.cmp
    BlinkCmpMenu = "Pmenu",
    BlinkCmpMenuBorder = "FloatBorder",
    BlinkCmpMenuSelection = "PmenuSel",
    BlinkCmpLabelMatch = { fg = c.accent, bold = true },
    BlinkCmpLabelDeprecated = { fg = c.comment, strikethrough = true },
    BlinkCmpKind = { fg = c.purple },
    BlinkCmpDoc = "NormalFloat",
    BlinkCmpDocBorder = "FloatBorder",

    -- nvim-tree
    NvimTreeNormal = { fg = c.fg, bg = c.bg_alt2 },
    NvimTreeNormalNC = { fg = c.fg, bg = c.bg_alt2 },
    NvimTreeWinSeparator = { fg = c.bg_alt2, bg = c.bg_alt2 },
    NvimTreeRootFolder = { fg = c.purple, bold = true },
    NvimTreeFolderName = { fg = c.blue },
    NvimTreeOpenedFolderName = { fg = c.blue, bold = true },
    NvimTreeEmptyFolderName = { fg = c.comment },
    NvimTreeFolderIcon = { fg = c.blue },
    NvimTreeIndentMarker = { fg = c.nontext },
    NvimTreeGitDirty = { fg = c.orange },
    NvimTreeGitNew = { fg = c.green },
    NvimTreeGitDeleted = { fg = c.red },
    NvimTreeSpecialFile = { fg = c.yellow, underline = true },
    NvimTreeCursorLine = { bg = c.bg_hl },

    -- neo-tree
    NeoTreeNormal = { fg = c.fg, bg = c.bg_alt2 },
    NeoTreeNormalNC = { fg = c.fg, bg = c.bg_alt2 },
    NeoTreeDirectoryName = { fg = c.blue },
    NeoTreeDirectoryIcon = { fg = c.blue },
    NeoTreeRootName = { fg = c.purple, bold = true },
    NeoTreeGitModified = { fg = c.orange },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitDeleted = { fg = c.red },
    NeoTreeGitUntracked = { fg = c.aqua },
    NeoTreeIndentMarker = { fg = c.nontext },

    -- oil
    OilDir = { fg = c.blue },

    -- indent-blankline / mini.indentscope / snacks indent
    IblIndent = { fg = util.blend(c.nontext, c.bg, 0.6) },
    IblWhitespace = { fg = util.blend(c.nontext, c.bg, 0.6) },
    IblScope = { fg = c.line_nr },
    MiniIndentscopeSymbol = { fg = c.line_nr },
    SnacksIndent = { fg = util.blend(c.nontext, c.bg, 0.6) },
    SnacksIndentScope = { fg = c.line_nr },

    -- which-key
    WhichKey = { fg = c.purple },
    WhichKeyGroup = { fg = c.blue },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { fg = c.comment },
    WhichKeyNormal = "NormalFloat",

    -- lazy / mason
    LazyNormal = "NormalFloat",
    LazyH1 = { fg = c.bg, bg = c.accent, bold = true },
    LazyButton = { fg = c.fg, bg = c.bg_hl },
    LazyButtonActive = { fg = c.bg, bg = c.accent, bold = true },
    LazySpecial = { fg = c.accent },
    MasonNormal = "NormalFloat",
    MasonHeader = { fg = c.bg, bg = c.accent, bold = true },
    MasonHighlight = { fg = c.accent },
    MasonHighlightBlock = { fg = c.bg, bg = c.accent },
    MasonHighlightBlockBold = { fg = c.bg, bg = c.accent, bold = true },
    MasonMuted = { fg = c.comment },
    MasonMutedBlock = { fg = c.fg, bg = c.bg_hl },

    -- noice / notify
    NoiceCmdlinePopupBorder = "FloatBorder",
    NoiceCmdlineIcon = { fg = c.accent },
    NotifyBackground = { bg = c.bg_alt },
    NotifyERRORBorder = { fg = c.red },
    NotifyWARNBorder = { fg = c.orange },
    NotifyINFOBorder = { fg = c.blue },
    NotifyDEBUGBorder = { fg = c.comment },
    NotifyTRACEBorder = { fg = c.purple },
    NotifyERRORIcon = { fg = c.red },
    NotifyWARNIcon = { fg = c.orange },
    NotifyINFOIcon = { fg = c.blue },
    NotifyERRORTitle = { fg = c.red },
    NotifyWARNTitle = { fg = c.orange },
    NotifyINFOTitle = { fg = c.blue },

    -- trouble
    TroubleNormal = { fg = c.fg, bg = c.bg_alt2 },
    TroubleNormalNC = { fg = c.fg, bg = c.bg_alt2 },

    -- flash / leap
    FlashLabel = { fg = c.bg, bg = c.orange, bold = true },
    FlashMatch = { fg = c.fg, bg = c.visual },
    FlashBackdrop = { fg = c.line_nr },
    LeapLabel = { fg = c.bg, bg = c.orange, bold = true },

    -- render-markdown
    RenderMarkdownH1Bg = { bg = util.blend(c.green, c.bg, 0.12) },
    RenderMarkdownH2Bg = { bg = util.blend(c.green, c.bg, 0.08) },
    RenderMarkdownH3Bg = { bg = util.blend(c.green, c.bg, 0.05) },
    RenderMarkdownH4Bg = { bg = c.bg_alt2 },
    RenderMarkdownH5Bg = { bg = c.bg_alt2 },
    RenderMarkdownH6Bg = { bg = c.bg_alt2 },
    RenderMarkdownCode = { bg = c.bg_alt2 },
    RenderMarkdownCodeInline = { fg = c.green, bg = c.bg_alt2 },
    RenderMarkdownBullet = { fg = c.red },
    RenderMarkdownLink = { fg = c.orange },

    -- mini.statusline / lualine fallback
    MiniStatuslineModeNormal = { fg = c.bg, bg = c.blue, bold = true },
    MiniStatuslineModeInsert = { fg = c.bg, bg = c.green, bold = true },
    MiniStatuslineModeVisual = { fg = c.bg, bg = c.purple, bold = true },
    MiniStatuslineModeReplace = { fg = c.bg, bg = c.red, bold = true },
    MiniStatuslineModeCommand = { fg = c.bg, bg = c.yellow, bold = true },
    MiniStatuslineDevinfo = { fg = c.fg, bg = c.bg_hl },
    MiniStatuslineFilename = { fg = c.fg, bg = c.bg_alt },
    MiniStatuslineFileinfo = { fg = c.fg, bg = c.bg_hl },

    -- dashboard / snacks
    SnacksDashboardHeader = { fg = c.purple },
    SnacksDashboardKey = { fg = c.orange },
    SnacksDashboardDesc = { fg = c.fg },
    SnacksDashboardIcon = { fg = c.blue },

    -- illuminate
    IlluminatedWordText = { bg = c.bg_hl },
    IlluminatedWordRead = { bg = c.bg_hl },
    IlluminatedWordWrite = { bg = c.bg_hl, underline = true },

    -- misc
    NeogitDiffAdd = { fg = c.green, bg = c.diff_add },
    NeogitDiffDelete = { fg = c.red, bg = c.diff_delete },
    NeogitHunkHeader = { fg = c.comment, bg = c.hunk_header },
    DiffviewFilePanelTitle = { fg = c.accent, bold = true },
    TreesitterContext = { bg = c.bg_alt2 },
    TreesitterContextLineNumber = { fg = c.line_nr, bg = c.bg_alt2 },
    TreesitterContextBottom = { underline = true, sp = c.border },
    SnacksNormal = { fg = c.fg, bg = bg },
  }
end
