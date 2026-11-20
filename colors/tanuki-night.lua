-- :colorscheme tanuki-night
-- Reload the theme modules (not config, which holds setup() options) so edits take effect.
for name in pairs(package.loaded) do
  if name:match("^tanuki%-night") and name ~= "tanuki-night.config" then
    package.loaded[name] = nil
  end
end
-- Vim re-sources the active colorscheme when 'background' changes:
-- ":set background=light" while tanuki-night is active switches to tanuki-day.
local style = "night"
if vim.g.colors_name == "tanuki-night" and vim.o.background == "light" then
  style = "day"
end
require("tanuki-night").load(style)
