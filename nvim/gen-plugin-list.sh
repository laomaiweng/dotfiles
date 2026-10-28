#!/bin/bash
# vim: ts=2 sts=2 sw=2 et

dir=${0%/*}
plugins_lua=$dir/lua/plugins.lua

plugins=$(sed -n -e '/^require("lazy").setup/,$ p' "$plugins_lua" | sed -e '1 s/.*/{/; $ s/.*/}/')

# Always print lazy.nvim (at the top, unsorted).
echo 'https://github.com/folke/lazy.nvim'

# And the Mason registries (useful when mirroring offline because Mason defaults to accessing those via the Github API).
echo 'https://github.com/mason-org/mason-registry'
echo 'https://github.com/mason-org/mason-system-registry'

lua <<EOF | sort -u
function plugin_url(p)
  local n
  local u

  if type(p) == "table" then
    -- Process dependencies
    local deps = p["dependencies"]
    if deps and type(deps) == "table" then
      local i
      local d
      for i,d in ipairs(deps) do
        plugin_url(d)
      end
    end

    if p["url"] then
      n = p["url"]
    else
      n = p[1]
    end
  else
    n = p
  end

  -- Skip local paths
  if n:find("/", 1, true) == 1 then
    return
  end

  if n:find("https://", 1, true) == 1 then
    u = n
  else
    u = "https://github.com/" .. n
  end

  print(u)
end

plugins=$plugins
for i,p in ipairs(plugins) do
  plugin_url(p)
end
EOF
