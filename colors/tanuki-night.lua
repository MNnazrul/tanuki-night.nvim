package.loaded["tanuki-night"] = nil
for name in pairs(package.loaded) do
  if name:match("^mn%-dark%.groups") or name == "tanuki-night.palette" then
    package.loaded[name] = nil
  end
end
require("tanuki-night").load()
