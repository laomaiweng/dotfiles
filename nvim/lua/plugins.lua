-- User plugins for Neovim
-- Sourced from init.vim.

-- Setup:
-- 1. install Packer:
--      git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
-- 2. install the Python client:
--      pip3 install --user pynvim
-- 3. install the Node client:
--      npm install -g neovim
-- 4. install external tools:
--      $package_manager install ripgrep
--      $package_manager install yarn  # for markdown-preview
--      $package_manager install universal-ctags  # for Coq
-- 5. setup plugins:
--      :PackerCompile
--      :PackerSync
-- 6. build telescope-fzf-native
-- 7. install LSPs
--      :LspInstallInfo
-- 8. profit!

-- Plugins to try out:
--    will133/vim-dirdiff
--    sindrets/diffview.nvim
--    nvim-orgmode/orgmode (+ enable as a source in coq.thirdparty)
--    lervag/vimtex (+ enable as a source in coq.thirdparty)
--    kristijanhusak/vim-dadbod-completion if I ever end up using vim-dadbod (+ enable as a source in coq.thirdparty)
--    m-pilia/vim-mediawiki

return require('packer').startup(function(use) -- "Define" `use` to prevent "undefined global" diagnostics.
  -- Self-manage
  use 'wbthomason/packer.nvim'

  -- Themes
  use 'EdenEast/nightfox.nvim'
  use 'shaunsingh/moonlight.nvim'
  use 'marko-cerovac/material.nvim'

  -- Utilities
  use 'kyazdani42/nvim-web-devicons'
  use 'nvim-lua/plenary.nvim'
  use 'mattn/webapi-vim'

  -- UI enhancements
  use 'vim-ctrlspace/vim-ctrlspace'
  use 'junegunn/vim-peekaboo'
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
  }
  use { 'andymass/vim-matchup', event = 'VimEnter' }
  use {
    'bounceme/poppy.vim',
    config = function()
      vim.cmd('autocmd! cursormoved * call PoppyInit()')
    end
  }
  use 'rhysd/clever-f.vim'
  use 'bronson/vim-visual-star-search'
  use 'itchyny/vim-cursorword'
  use 'Shougo/vinarise.vim'
  use 'moll/vim-bbye'
  use 'mbbill/undotree'
  use 'tpope/vim-obsession'
  use { 'junkblocker/patchreview-vim', cmd = { 'DiffReview', 'PatchReview', 'ReversePatchReview' } }
  use 'arkav/lualine-lsp-progress'
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true },
      { 'lewis6991/gitsigns.nvim', opt = true },
      { 'nvim-treesitter/nvim-treesitter', opt = true },
      { 'arkav/lualine-lsp-progress', opt = true },
    },
    config = function()
      -- formatting helper
      -- source: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#truncating-components-in-smaller-window
      --- @param trunc_width number  truncates component when screen width is less than trunc_width
      --- @param trunc_len   number  truncates component to trunc_len number of chars
      --- @param hide_width  number  hides component when window width is smaller then hide_width
      --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
      --- return function that can format the component accordingly
      local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
        return function(str)
          local win_width = vim.fn.winwidth(0)
          if hide_width and win_width < hide_width then return ''
          elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
             return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
          end
          return str
        end
      end

      -- use gitsigns' diff info
      -- source: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-diff
      -- (don't need the "Using external source for branch" from the above page, the 'fugitive' lualine extension already does this)
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
          }
        end
      end

      -- get the current function from treesitter
      -- from: https://github.com/nvim-lualine/lualine.nvim/issues/409
      -- this is kind of buggy, e.g. here in plugins.lua, or elsewhere, see https://github.com/nvim-treesitter/nvim-treesitter/issues/1931
      local treesitter = require('nvim-treesitter')
      local function treelocation()
        return treesitter.statusline({
          indicator_size = vim.fn.winwidth(0),
          type_patterns = { 'class', 'function', 'method' },
          separator = ' -> '
        })
      end

      require('lualine').setup {
        options = { theme = 'nightfox' },
        extensions = { 'chadtree', 'fugitive', 'quickfix' },
        sections = {
          -- truncate the mode if the window gets too small
          lualine_a = { { 'mode', fmt = trunc(80, 1, nil, true) }, },
          -- draw diff info from gitsigns
          lualine_b = { 'branch', { 'diff', source = diff_source }, 'filename' },
          -- display current function & LSP progress messages
          lualine_c = { 'diagnostics', { treelocation, fmt = trunc(120, 30, 80, false) },
            {
              'lsp_progress',
              spinner_symbols = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
              fmt = trunc(120, 40, 80, false)
            },
          },
          lualine_x = { 'encoding', 'fileformat' },
          lualine_y = { 'filetype' },
          lualine_z = { 'progress', 'location' },
        },
      }
    end
  }
  use {
    'kdheepak/tabline.nvim',
    requires = { { 'nvim-lualine/lualine.nvim', opt = true }, { 'kyazdani42/nvim-web-devicons', opt = true } },
    config = function()
      require('tabline').setup { enable = true, }
    end
  }
  use 'stevearc/dressing.nvim'
  use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
      require('alpha').setup(require('alpha.themes.startify').config)
    end
  }
  use {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end
  }

  use {
    'Leandros/telescope-fzf-native.nvim', -- not the official repo, but a fork w/ Windows build support
    branch = 'feature/windows_build_support',
  }
  use 'nvim-telescope/telescope-packer.nvim'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'nvim-telescope/telescope-github.nvim'
  use 'nvim-telescope/telescope-symbols.nvim'
  use 'crispgm/telescope-heading.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      local telescope = require('telescope')
      local trouble = require('trouble.providers.telescope')
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<c-h>'] = 'which_key',
              ['<c-space>'] = trouble.open_with_trouble
            },
            n = {
              ['<c-space>'] = trouble.open_with_trouble
            },
          }
        },
        pickers = {
          lsp_code_actions = { theme = 'cursor' },
          lsp_range_code_actions = { theme = 'cursor' },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown{},
          },
        },
      }
      telescope.load_extension('fzf')
      telescope.load_extension('packer')
      telescope.load_extension('dap')
      telescope.load_extension('gh')
      telescope.load_extension('notify')
      telescope.load_extension('heading')
    end
  }

  -- Editing helpers
  -- NOTE: vim-endwise & vim-closer have been disabled because they both try to extend the Insert-mode <CR> mapping, but
  --       this conflicts with and breaks Coq's expr mapping on <CR>
  --       a choice had to be made: auto-completion or auto-closing syntax elements, auto-completion won
  --       see also:
  --         * https://github.com/ms-jpq/coq_nvim/issues/384
  --         * https://github.com/tpope/vim-endwise/issues/109
  --         * https://github.com/rstacruz/vim-closer/issues/37
  use 'tpope/vim-abolish'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  -- use 'tpope/vim-endwise'
  -- use 'rstacruz/vim-closer'
  use 'vim-scripts/argtextobj.vim'
  use 'bkad/CamelCaseMotion'
  use {
    'tweekmonster/braceless.vim',
    config = function()
      vim.cmd('autocmd FileType python BracelessEnable +indent +fold')
    end
  }
  use 'b4winckler/vim-angry'
  use 'junegunn/vim-easy-align'
  use 'tommcdo/vim-exchange'
  use 'michaeljsmith/vim-indent-object'
  use 'mg979/vim-visual-multi'

  -- Filetypes
  use 'ron-rs/ron.vim'
  use 'fedorenchik/qt-support.vim'
  use 'rust-lang/rust.vim' -- Still useful in Neovim, for Playpen integration + running single tests from Vim.
  use 'bfrg/vim-cpp-modern'
  use 'lark-parser/vim-lark-syntax'

  -- Tooling integration
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }
  use { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Focus', 'Start' } }
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }
  use 'vim-autoformat/vim-autoformat'
  use { 'tpope/vim-dadbod', cmd = 'DB' }
  use 'christianrondeau/vim-base64'
  use 'jamessan/vim-gnupg'
  use 'jmcantrell/vim-virtualenv'

  -- Debug adapters
  use {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')
      dap.adapters.lldb = {
        type = 'executable',
        command = 'lldb-vscode',
        name = 'lldb'
      }
      dap.configurations.c = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
        {
          name = 'Launch with args',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, ' +')
          end;
        },
        {
          -- If you get an "Operation not permitted" error using this, try disabling YAMA:
          --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
          name = 'Attach to process',
          type = 'lldb',
          request = 'attach',
          pid = require('dap.utils').pick_process,
          args = {},
        },
      }
      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c
    end
  }

  -- Completers, analyzers
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'c_sharp', 'cmake', 'cpp', 'css', 'dockerfile', 'dot', 'go', 'html', 'javascript', 'json', 'latex', 'llvm', 'lua', 'make', 'markdown', 'python', 'regex', 'rst', 'rust', 'toml', 'vim' },
        sync_install = true,
        highlight = {
          enable = true,
          disable = { 'bash', 'markdown', 'toml' },  -- TS highlighting seems to suck in these
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        matchup = { enable = true },
      }
    end
  }
  use { 'ms-jpq/coq_nvim', branch = 'coq' }
  use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
  use {
    'ms-jpq/coq.thirdparty',
    branch = '3p',
    config = function()
      require('coq_3p') {
        { src = 'nvimlua', short_name = 'nLUA', conf_only = true },
        { src = 'bc', short_name = 'CALC', precision = 6 },
        { src = 'cow', trigger = '!cow' },
        { src = 'figlet', trigger = '!fig' },
        { src = 'dap' },
      }
    end
  }

  -- LSP stuff
  use 'williamboman/mason.nvim'
  use { 'williamboman/mason-lspconfig.nvim',
    requires = 'williamboman/mason.nvim',
  }
  use 'simrat39/rust-tools.nvim'
  use {
    'neovim/nvim-lspconfig',
    requires = { 'williamboman/mason-lspconfig.nvim', 'simrat39/rust-tools.nvim', 'ms-jpq/coq_nvim', },
    config = function()
      require('mason').setup()
      local mason_lspconfig = require('mason-lspconfig')
      mason_lspconfig.setup()
      local lspconfig = require('lspconfig')
      local coq = require('coq')
      mason_lspconfig.setup_handlers {
        -- Default handler
        function (server_name)
          lspconfig[server_name].setup(coq.lsp_ensure_capabilities {})
        end,

        ['rust_analyzer'] = function()
          require('rust-tools').setup(coq.lsp_ensure_capabilities {})
        end,

        ['sumneko_lua'] = function()
          lspconfig.sumneko_lua.setup(coq.lsp_ensure_capabilities {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' }
                }
              }
            }
          })
        end,
      }
    end
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'lewis6991/gitsigns.nvim', 'ms-jpq/coq_nvim', },
    config = function()
      local null_ls = require('null-ls')
      local coq = require('coq')
      null_ls.setup(coq.lsp_ensure_capabilities {
        sources = {
          null_ls.builtins.code_actions.gitsigns,
        },
      })
    end
  }

  -- Full-blown tools
  use { 'ms-jpq/chadtree', branch = 'chad', run = 'python -m chadtree deps', cmd = 'CHADopen' }
end)
