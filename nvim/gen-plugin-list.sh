#!/bin/bash

dir=${0%/*}
plugins_lua=$dir/lua/plugins.lua

plugins=$(sed -n -e '/^require("lazy").setup/,$ p' "$plugins_lua" | sed -e '1 s/.*/{/; $ s/.*/}/')

# Always print lazy.nvim (at the top, unsorted)
echo 'https://github.com/folke/lazy.nvim'

lua <<EOF | sort -u
plugins=$plugins
for i,p in ipairs(plugins) do
  if type(p) == "table" then
    n = p[1]
  else
    n = p
  end

  if n:find("https://", 1, true) == 1 then
    u = n
  else
    u = "https://github.com/" .. n
  end

  print(u)
end
EOF
