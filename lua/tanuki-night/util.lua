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

-- sRGB "#rrggbb" channels -> CIE L*a*b* (D65), for distances that match how colors look
local function lab(r, g, b)
  local function lin(c)
    c = c / 255
    return c > 0.04045 and ((c + 0.055) / 1.055) ^ 2.4 or c / 12.92
  end
  r, g, b = lin(r), lin(g), lin(b)
  local x = (0.4124 * r + 0.3576 * g + 0.1805 * b) / 0.95047
  local y = 0.2126 * r + 0.7152 * g + 0.0722 * b
  local z = (0.0193 * r + 0.1192 * g + 0.9505 * b) / 1.08883
  local function f(t)
    return t > 0.008856 and t ^ (1 / 3) or 7.787 * t + 16 / 116
  end
  x, y, z = f(x), f(y), f(z)
  return 116 * y - 16, 500 * (x - y), 200 * (y - z)
end

-- xterm-256 palette entries 16..255 as { index, L, a, b, grey }
-- (0..15 are left out: they depend on the terminal's own palette)
local xterm
local function xterm_palette()
  if xterm then
    return xterm
  end
  xterm = {}
  local function add(index, r, g, b)
    local l, a, bb = lab(r, g, b)
    xterm[#xterm + 1] = { index, l, a, bb, r == g and g == b }
  end
  local levels = { 0, 95, 135, 175, 215, 255 }
  for i = 0, 215 do
    add(16 + i, levels[math.floor(i / 36) + 1], levels[math.floor(i / 6) % 6 + 1], levels[i % 6 + 1])
  end
  for i = 0, 23 do
    local v = 8 + 10 * i
    add(232 + i, v, v, v)
  end
  return xterm
end

--- Nearest xterm-256 color index (16..255) for a "#rrggbb" color.
--- `avoid`: an index, or a set { [index] = true }, that must not be returned.
function M.to_256(hex, avoid)
  if type(avoid) == "number" then
    avoid = { [avoid] = true }
  end
  avoid = avoid or {}
  local r, g, b = rgb(hex)
  local l, a, bb = lab(r, g, b)
  -- a tinted color (diff green, search orange) must stay tinted: plain distance often picks
  -- a grey for pale or dark tints, and diff/search colors would all look the same
  -- and keep its hue (within 30 degrees), so green stays green and doesn't drift to brown
  local tinted = math.max(r, g, b) - math.min(r, g, b) >= 8
  local hue = math.atan2 and math.atan2(bb, a) or math.atan(bb, a)
  local function same_hue(c)
    local h = math.atan2 and math.atan2(c[4], c[3]) or math.atan(c[4], c[3])
    local d = math.abs(h - hue) % (2 * math.pi)
    return math.min(d, 2 * math.pi - d) <= math.pi / 6
  end
  local best, best_dist
  for _, c in ipairs(xterm_palette()) do
    if not avoid[c[1]] and not (tinted and (c[5] or not same_hue(c))) then
      local dist = (l - c[2]) ^ 2 + (a - c[3]) ^ 2 + (bb - c[4]) ^ 2
      if not best_dist or dist < best_dist then
        best, best_dist = c[1], dist
      end
    end
  end
  return best
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
