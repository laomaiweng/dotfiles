#!/bin/bash

# don't add --clangd-completer since (as of 2019-10-29 at least) all it does is download clangd from the web
# instead, just set `let g:ycm_clangd_binary_path = '/path/to/clangd'` in your .vimrc
cmd=(./YouCompleteMe/install.py --ninja --system-boost --system-libclang --clang-completer --go-completer --rust-completer --java-completer --ts-completer)

echo "> ${cmd[*]}
"

"${cmd[@]}"
