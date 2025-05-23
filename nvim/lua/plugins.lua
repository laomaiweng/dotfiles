-- User plugins for Neovim
-- Sourced from init.vim.

-- Setup:
-- 1. install the Python client:
--      pip3 install --user pynvim
-- 2. install the Node client:
--      npm install -g neovim
-- 3. install external tools:
--      $package_manager install ripgrep
--      $package_manager install yarnpkg  # for markdown-preview
--      $package_manager install python3-venv universal-ctags sqlite3  # for Coq
-- 4. install LSPs
--      :Mason
-- 5. install COQ & CHADtree dependencies
--      :COQdeps
--      :CHADdeps
-- 6. profit!

-- Plugins to try out:
--    will133/vim-dirdiff
--    sindrets/diffview.nvim
--    nvim-orgmode/orgmode (+ enable as a source in coq.thirdparty)
--    lervag/vimtex (+ enable as a source in coq.thirdparty)
--    kristijanhusak/vim-dadbod-completion if I ever end up using vim-dadbod (+ enable as a source in coq.thirdparty)
--    m-pilia/vim-mediawiki

-- Auto-install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorschemes
  {
    "calind/selenized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1001, -- make sure to load this before all the other start plugins
    -- config = function()
    --   -- load the colorscheme here
    --   vim.cmd([[colorscheme selenized]])
    -- end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1001, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme nightfox]])
    end,
  },
  "marko-cerovac/material.nvim",

  -- Utilities
  "nvim-lua/plenary.nvim",
  "mattn/webapi-vim",

  -- UI enhancements
  "vim-ctrlspace/vim-ctrlspace",
  {
    "tversteeg/registers.nvim",
    config = function()
      require("registers").setup()
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
  },
  { "andymass/vim-matchup", event = "VimEnter" },
  {
    "bounceme/poppy.vim",
    config = function()
      vim.cmd("autocmd! cursormoved * call PoppyInit()")
    end
  },
  "rhysd/clever-f.vim",
  "bronson/vim-visual-star-search",
  "itchyny/vim-cursorword",
  "Shougo/vinarise.vim",
  "moll/vim-bbye",
  "mbbill/undotree",
  "tpope/vim-obsession",
  { "junkblocker/patchreview-vim", cmd = { "DiffReview", "PatchReview", "ReversePatchReview" } },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      { "lewis6991/gitsigns.nvim", optional = true },
      { "nvim-treesitter/nvim-treesitter", optional = true },
      "arkav/lualine-lsp-progress",
    },
    config = function()
      -- formatting helper
      -- source: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#truncating-components-in-smaller-window
      --- @param trunc_width number  truncates component when screen width is less than trunc_width
      --- @param trunc_len   number  truncates component to trunc_len number of chars
      --- @param hide_width  number  hides component when window width is smaller then hide_width
      --- @param no_ellipsis boolean whether to disable adding "..." at end after truncation
      --- return function that can format the component accordingly
      local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
        return function(str)
          local win_width = vim.fn.winwidth(0)
          if hide_width and win_width < hide_width then return ""
          elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
             return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
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
      local treesitter = require("nvim-treesitter")
      local function treelocation()
        return treesitter.statusline({
          indicator_size = vim.fn.winwidth(0),
          type_patterns = { "class", "function", "method" },
          separator = " -> "
        })
      end

      require("lualine").setup {
        options = {
          -- theme = "solarized_dark", -- for colorscheme "selenized"
          theme = "ayu_mirage", -- for colorscheme "nightfox"
        },
        extensions = { "chadtree", "fugitive", "quickfix" },
        sections = {
          -- truncate the mode if the window gets too small
          lualine_a = { { "mode", fmt = trunc(80, 1, nil, true) }, },
          -- draw diff info from gitsigns
          lualine_b = { "branch", { "diff", source = diff_source }, "filename" },
          -- display current function & LSP progress messages
          lualine_c = { "diagnostics", { treelocation, fmt = trunc(120, 30, 80, false) },
            {
              "lsp_progress",
              spinner_symbols = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
              fmt = trunc(120, 40, 80, false)
            },
          },
          lualine_x = { "encoding", "fileformat" },
          lualine_y = { "filetype" },
          lualine_z = { "progress", "location" },
        },
      }
    end
  },
  {
    "kdheepak/tabline.nvim",
    dependencies = {
      { "nvim-lualine/lualine.nvim", optional = true },
      "nvim-tree/nvim-web-devicons"
    },
    config = function()
      require("tabline").setup { enable = true, }
    end
  },
  "stevearc/dressing.nvim",
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function ()
      local theme = require("alpha.themes.startify")

      -- Default header when `toilet` isn't available
      theme.section.header.val = {
        "                                                            ",
        "                                                            ",
        "                                            ██              ",
        "                                            ██              ",
        "                                            ██              ",
        "                                                            ",
        " ██░████    ░████▒    ░████░   ██▒  ▒██   ████     ██▓█▒██▒ ",
        " ███████▓  ░██████▒  ░██████░  ▓██  ██▓   ████     ████████ ",
        " ███  ▒██  ██▒  ▒██  ███  ███  ▒██  ██▒     ██     ██░██░██ ",
        " ██    ██  ████████  ██░  ░██   ██░░██      ██     ██ ██ ██ ",
        " ██    ██  ████████  ██    ██   ██▒▒██      ██     ██ ██ ██ ",
        " ██    ██  ██        ██░  ░██   ▒████▒      ██     ██ ██ ██ ",
        " ██    ██  ███░  ▒█  ███  ███    ████       ██     ██ ██ ██ ",
        " ██    ██  ░███████  ░██████░    ████    ████████  ██ ██ ██ ",
        " ██    ██   ░█████▒   ░████░     ▒██▒    ████████  ██ ██ ██ ",
        "                                                            ",
        "                                                            ",
        "                                                            ",
        "                                                            ",
      }

      -- Switch between various fonts, inspired by:
      -- https://github.com/AdamWhittingham/vim-config/blob/nvim/lua/config/plugins/alpha-nvim.lua
      if vim.fn.executable("toilet") == 1 then
        local big_fonts = { "ascii12", "bigascii12", "bigmono12", "mono12", }
        local small_fonts = { "future", "letter", "pagga", "smblock", "smbraille" }
        local fonts = vim.fn.winheight(0) > 40 and big_fonts or small_fonts

        math.randomseed(os.time())
        local font = fonts[math.random(#fonts)]

        local handle = io.popen("toilet -f " .. font .. " neovim")
        if handle then
          -- Read line-by-line because we need a table of lines, not a single big string with newlines
          local header = {}
          for l in handle:lines() do
            table.insert(header, l)
          end
          handle:close()

          theme.section.header.val = header
        end
      end

      require("alpha").setup(theme.config)
    end
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "tsakirist/telescope-lazy.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-github.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "fdschmidt93/telescope-egrepify.nvim",
      "crispgm/telescope-heading.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<c-h>"] = "which_key",
              ["<c-space>"] = require("trouble.sources.telescope").open
            },
            n = {
              ["<c-space>"] = require("trouble.sources.telescope").open
            },
          }
        },
        pickers = {
          lsp_code_actions = { theme = "cursor" },
          lsp_range_code_actions = { theme = "cursor" },
        },
        extensions = {
          egrepify = {
            AND = false, -- By default, don't intersect tokens in prompt
          },
          file_browser = {
            hijack_netrw = true,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown{},
          },
        },
      }
      telescope.load_extension("dap")
      telescope.load_extension("egrepify")
      telescope.load_extension("file_browser")
      telescope.load_extension("fzf")
      telescope.load_extension("gh")
      telescope.load_extension("heading")
      telescope.load_extension("lazy")
      telescope.load_extension("notify")

      function vim.getVisualSelection()
	local current_clipboard_content = vim.fn.getreg('"')

	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	vim.fn.setreg('"', current_clipboard_content)

	text = string.gsub(text, "\n", "")
	if #text > 0 then
          return text
	else
          return ''
	end
      end

      -- Search for selected text in visual mode
      vim.keymap.set('v', '<leader>tG',
        function()
              local text = vim.getVisualSelection()
              require("telescope.builtin").grep_string({ search = text })
        end,
        {noremap = true, silent = true})
    end
  },
  "rhysd/committia.vim",
  {
    "junegunn/gv.vim",
    dependencies = {
      "tpope/vim-fugitive",
    }
  },

  -- Editing helpers
  -- NOTE: vim-endwise & vim-closer have been disabled because they both try to extend the Insert-mode <CR> mapping, but
  --       this conflicts with and breaks Coq's expr mapping on <CR>
  --       a choice had to be made: auto-completion or auto-closing syntax elements, auto-completion won
  --       see also:
  --         * https://github.com/ms-jpq/coq_nvim/issues/384
  --         * https://github.com/tpope/vim-endwise/issues/109
  --         * https://github.com/rstacruz/vim-closer/issues/37
  "tpope/vim-abolish",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-speeddating",
  "tpope/vim-commentary",
  "tpope/vim-surround",
  -- "tpope/vim-endwise",
  -- "rstacruz/vim-closer",
  "vim-scripts/argtextobj.vim",
  "bkad/CamelCaseMotion",
  {
    "tweekmonster/braceless.vim",
    config = function()
      vim.cmd("autocmd FileType python BracelessEnable +indent +fold")
    end
  },
  "b4winckler/vim-angry",
  "junegunn/vim-easy-align",
  "tommcdo/vim-exchange",
  "michaeljsmith/vim-indent-object",
  "mg979/vim-visual-multi",
  {
    "RaafatTurki/hex.nvim",
    config = function()
      require("hex").setup()
    end
  },

  -- Filetypes
  "ron-rs/ron.vim",
  "fedorenchik/qt-support.vim",
  "rust-lang/rust.vim", -- Still useful in Neovim, for Playpen integration + running single tests from Vim.
  "bfrg/vim-cpp-modern",
  "rhysd/vim-llvm",
  "lark-parser/vim-lark-syntax",

  -- Tooling integration
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup()
    end
  },
  { "tpope/vim-dispatch", cmd = { "Dispatch", "Make", "Focus", "Start" } },
  { "iamcco/markdown-preview.nvim", build = "cd app && yarnpkg install", cmd = "MarkdownPreview" },
  "vim-autoformat/vim-autoformat",
  { "tpope/vim-dadbod", cmd = "DB" },
  "christianrondeau/vim-base64",
  "jamessan/vim-gnupg",
  "jmcantrell/vim-virtualenv",

  -- Debug adapters
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-vscode",
        name = "lldb"
      }
      dap.configurations.c = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Launch with args",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end;
        },
        {
          -- If you get an "Operation not permitted" error using this, try disabling YAMA:
          --  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
          name = "Attach to process",
          type = "lldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }
      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c
    end
  },

  -- Completers, analyzers
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "bash", "c", "c_sharp", "cmake", "cpp", "css", "dockerfile", "dot", "go", "html", "javascript", "json", "latex", "llvm", "lua", "make", "markdown", "python", "regex", "rst", "rust", "toml", "vim" },
        sync_install = true,
        highlight = {
          enable = true,
          disable = { "bash", "markdown", "toml" },  -- TS highlighting seems to suck in these
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        matchup = { enable = true },
      }
    end
  },
  { "ms-jpq/coq_nvim", branch = "coq" },
  { "ms-jpq/coq.artifacts", branch = "artifacts" },
  {
    "ms-jpq/coq.thirdparty",
    branch = "3p",
    config = function()
      require("coq_3p") {
        { src = "nvimlua", short_name = "nLUA", conf_only = true },
        { src = "bc", short_name = "CALC", precision = 6 },
        { src = "cow", trigger = "!cow" },
        { src = "figlet", trigger = "!fig" },
        { src = "dap" },
      }
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      -- ASCII hints to use instead of the default :panda: emoji
      hint_prefix = {
        above = "↙ ",
        current = "← ",
        below = "↖ "
      },
      hint_inline = function() return "eol" end,
      toggle_key = "<C-k>",
      select_signature_key = "<C-n>",
    },
  },

  -- LSP stuff
  "williamboman/mason.nvim",
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,   -- This plugin is already lazy
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "mrcjkb/rustaceanvim", "ms-jpq/coq_nvim", },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
      local coq = require("coq")

      -- Default handler
      vim.lsp.config("*", coq.lsp_ensure_capabilities {})

      vim.lsp.config("lua_ls",
        coq.lsp_ensure_capabilities {
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files and plugins
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            }
          }
        }
      )
    end
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "lewis6991/gitsigns.nvim", "ms-jpq/coq_nvim", },
    config = function()
      local null_ls = require("null-ls")
      local coq = require("coq")
      null_ls.setup(coq.lsp_ensure_capabilities {
        sources = {
          null_ls.builtins.code_actions.gitsigns,
        },
      })
    end
  },

  -- Full-blown tools
  { "ms-jpq/chadtree", branch = "chad", build = "python3 -m chadtree deps", cmd = "CHADopen" },
})
