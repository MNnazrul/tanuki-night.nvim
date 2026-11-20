local M = {}

local function rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

--- Blend `fg` over `bg` with `alpha` (0..1, 1 = all fg).
function M.blend(fg, bg, alpha)
  local r1, g1, b1 = rgb(fg)
  local r2, g2, b2 = rgb(bg)
  local function c(a, b)
    return math.floor(math.min(math.max(0, alpha * a + (1 - alpha) * b), 255) + 0.5)
  end
  return string.format("#%02x%02x%02x", c(r1, r2), c(g1, g2), c(b1, b2))
end

--- Apply a highlight table { Group = attrs | "LinkTarget" }.
function M.apply(groups)
  for name, spec in pairs(groups) do
    if type(spec) == "string" then
      spec = { link = spec }
    end
    vim.api.nvim_set_hl(0, name, spec)
  end
end

return M
