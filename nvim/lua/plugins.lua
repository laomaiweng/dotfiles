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
--    simrat39/rust-tools.nvim

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
  use 'bounceme/poppy.vim'
  use 'rhysd/clever-f.vim'
  use 'bronson/vim-visual-star-search'
  use 'itchyny/vim-cursorword'
  use 'Shougo/vinarise.vim'
  use 'moll/vim-bbye'
  use 'mbbill/undotree'
  use 'tpope/vim-obsession'
  use { 'junkblocker/patchreview-vim', cmd = { 'DiffReview', 'PatchReview', 'ReversePatchReview' } }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        options = { theme = 'nightfox' },
        extensions = { 'chadtree', 'fugitive', 'quickfix' },
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
      require('alpha').setup(require('alpha.themes.startify').opts)
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
  use 'tpope/vim-abolish'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-commentary'
  use 'tpope/vim-endwise'
  use 'tpope/vim-surround'
  use 'rstacruz/vim-closer'
  use 'vim-scripts/argtextobj.vim'
  use 'bkad/CamelCaseMotion'
  use 'tweekmonster/braceless.vim'
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
  use {
    'mfussenegger/nvim-dap-python',
    config = function()
      require('dap-python').setup('C:/Program Files/Python310/python.exe')
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
        highlight = { enable = true },
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
  use {
    'neovim/nvim-lspconfig',
    requires = 'ms-jpq/coq_nvim'
  }
  use {
    'williamboman/nvim-lsp-installer',
    config = function()
      local coq = require('coq')
      require('nvim-lsp-installer').on_server_ready(function(server)
        local opts = {}
        server:setup(coq.lsp_ensure_capabilities(opts))
      end)
    end
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = 'lewis6991/gitsigns.nvim',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup {
        sources = {
          null_ls.builtins.code_actions.gitsigns,
        },
      }
    end
  }

  -- Full-blown tools
  use { 'ms-jpq/chadtree', branch = 'chad', run = 'python -m chadtree deps', cmd = 'CHADopen' }
end)
