" %LOCALAPPDATA%\nvim\init.vim
" User settings for Neovim

" Load plugins
lua require('plugins')

" Change the mapleader for bépo
let mapleader = ";"

"" Theme settings
if has('gui_running')
    set background=light
else
    set background=dark
endif
colorscheme nightfox    " couldn't find a Solarized Dark theme with good support for treesitter et al. :(
" The font is set in ginit.vim, because `set guifont=` doesn't work with my
" Nerd Fonts for some reason (Neovim rejects the font and keeps the default).
set termguicolors
" Display non-breaking spaces, tabs and trailing spaces
set list
set listchars=nbsp:¤,tab:\|\ ,trail:•
highlight SpecialKey ctermfg=Black
" Highlight the current line
set cursorline

"" Options
" Misc
set wildmenu            " Enhanced tab completion
set number              " Show line numbers
set noswapfile          " Don't use them pesky swap files
set laststatus=2        " Always put a status line, even when there's only one window
set modeline            " Enable the modeline
" Formatting
set tabstop=4           " A tab is 4 spaces, the rest is up to tpope/vim-sleuth
set foldmethod=manual   " Let the user decide what to fold
set nofoldenable        " Don't fold anything by default
" Search
set ignorecase
set smartcase           " Ignore case if search pattern is all lowercase
set incsearch           " Show matches as you type
set hlsearch            " Highlight matches
" Navigation
set jumpoptions=stack   " Finally a way around Vim's confusing jumplist
set mouse=a
" Specific overrides
"  Use the n man section in Tcl files
autocmd FileType tcl setlocal keywordprg=man\ n
"  Syntax-highlight apparmor profiles
augroup apparmor
    autocmd!
    autocmd BufNewFile,BufRead /etc/apparmor.d/*                    set filetype=apparmor
    autocmd BufNewFile,BufRead /usr/share/apparmor/extra-profiles/* set filetype=apparmor
augroup end

"" Key bindings
" Fn keys
set pastetoggle=<F2>
nnoremap <F1> <cmd>CHADopen<cr>
nnoremap <F3> <cmd>make<cr>
nnoremap <F4> <cmd>UndotreeToggle<cr>
nnoremap <F5> <cmd>Autoformat<cr>
vnoremap <F5> <esc><cmd>Autoformat<cr>
" Navigate the buffers
nmap gb <cmd>bnext<cr>
nmap gB <cmd>bprevious<cr>
" Clear the current search with ;/
nmap <silent> <leader>/ <cmd>nohlsearch<cr>
" vim-easy-align
xmap gA <plug>(EasyAlign)
nmap gA <plug>(EasyAlign)
" LSP functions (some via Telescope)
nnoremap <c-e> <cmd>lua vim.diagnostic.open_float()<cr>
nnoremap gd <cmd>Telescope diagnostics<cr>
nnoremap <leader>D <cmd>call v:lua.toggle_diagnostics()<cr>
nnoremap <c-k> <cmd>lua vim.lsp.buf.hover()<cr>
nnoremap <leader>k <cmd>lua vim.lsp.buf.signature_help()<cr>
nnoremap <leader>r <cmd>lua vim.lsp.buf.rename()<cr>
nnoremap <leader>a <cmd>Telescope lsp_code_actions<cr>
"vnoremap <leader>a <esc><cmd>Telescope lsp_range_code_actions<cr>    " Can't get this mapping to work, it seems to call lsp_code_actions?
nnoremap <leader>s <cmd>Telescope lsp_document_symbols<cr>
nnoremap <leader>S <cmd>Telescope lsp_workspace_symbols<cr>
nnoremap g[ <cmd>Telescope lsp_references<cr>
nnoremap g] <cmd>Telescope lsp_definitions<cr>
nnoremap g( <cmd>lua vim.lsp.buf.incoming_calls()<cr>
nnoremap g) <cmd>lua vim.lsp.buf.outgoing_calls()<cr>
" Telescope-specific queries
nnoremap <leader>tf <cmd>Telescope find_files<cr>
nnoremap <leader>tg <cmd>Telescope grep_string<cr>
nnoremap <leader>tG <cmd>Telescope live_grep<cr>
vnoremap <leader>tG "zy:Telescope live_grep default_text=<c-r>z<cr>
nnoremap <leader>tb <cmd>Telescope buffers<cr>
nnoremap <leader>gf <cmd>Telescope git_files<cr>
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
nnoremap <leader>gC <cmd>Telescope git_bcommits<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>
nnoremap <leader>gS <cmd>Telescope git_stash<cr>
nnoremap <leader>gb <cmd>Telescope git_branches<cr>
" Trouble navigation
nnoremap g< <cmd>lua require('trouble').previous({skip_groups = true, jump = true});<cr>
nnoremap g> <cmd>lua require('trouble').next({skip_groups = true, jump = true});<cr>
" nvim-dap bindings
nnoremap <silent> <F6> <cmd>lua require('dap').continue()<cr>
nnoremap <silent> <F10> <cmd>lua require('dap').step_over()<cr>
nnoremap <silent> <F11> <cmd>lua require('dap').step_into()<cr>
nnoremap <silent> <F12> <cmd>lua require('dap').step_out()<cr>
nnoremap <silent> <leader>dl <cmd>Telescope dap list_breakpoints<cr>
nnoremap <silent> <leader>dv <cmd>Telescope dap variables<cr>
nnoremap <silent> <leader>df <cmd>Telescope dap frames<cr>
nnoremap <silent> <leader>db <cmd>lua require('dap').toggle_breakpoint()<cr>
nnoremap <silent> <leader>dB <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
nnoremap <silent> <leader>dt <cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Trace point message: '))<cr>
nnoremap <silent> <leader>dr <cmd>lua require('dap').repl.open()<cr>
nnoremap <silent> <leader>dR <cmd>lua require('dap').run_last()<cr>
augroup dap_python
    autocmd!
    autocmd FileType python nnoremap <silent> <leader>dtm <cmd>lua require('dap-python').test_method()<cr>
    autocmd FileType python nnoremap <silent> <leader>dtc <cmd>lua require('dap-python').test_class()<cr>
    autocmd FileType python vnoremap <silent> <leader>ds <esc><cmd>lua require('dap-python').debug_selection()<cr>
augroup end

"" Functions
lua <<LUA_EOF
-- Function to enable/disable diagnostics.
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
        vim.g.diagnostics_visible = false
        vim.diagnostic.disable()
        print('Disabled diagnostics.')
    else
        vim.g.diagnostics_visible = true
        vim.diagnostic.enable()
        print('Enabled diagnostics.')
    end
end
LUA_EOF

"" Packer config
" Run :PackerCompile upon modification of plugins.lua.
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end

"" CtrlSpace config
set hidden
let g:CtrlSpaceDefaultMappingKey = '<c-space> '

"" Coq config
" The default keybind for manually triggering completions is <c-space>, which
" collides with CtrlSpace. Use <c-tab> for manual completions.
let g:coq_settings = { 'keymap.manual_complete': '<c-tab>', 'auto_start': 'shut-up' }

"" CamelCaseMotion config
" Maps <leader>{w,b,e,ge} to camel-case motions.
let g:camelcasemotion_key = '<leader>'

"" clever-f config
let g:clever_f_across_no_line = 1
let g:clever_f_fix_key_direction = 1
let g:clever_f_timeout_ms = 1500
let g:clever_f_highlight_timeout_ms = 1500
