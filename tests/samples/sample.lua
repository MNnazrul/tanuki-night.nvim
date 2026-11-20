local utils = {}
function utils.print(m)
  if m == "" then
    return nil
  end
  print(string.format("[x] %s", m))
end
