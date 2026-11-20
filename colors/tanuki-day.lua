-- :colorscheme tanuki-day
-- Reload the theme modules (not config, which holds setup() options) so edits take effect.
for name in pairs(package.loaded) do
  if name:match("^tanuki%-night") and name ~= "tanuki-night.config" then
    package.loaded[name] = nil
  end
end
-- Vim re-sources the active colorscheme when 'background' changes:
-- ":set background=dark" while tanuki-day is active switches to tanuki-night.
local style = "day"
if vim.g.colors_name == "tanuki-day" and vim.o.background == "dark" then
  style = "night"
end
require("tanuki-night").load(style)
