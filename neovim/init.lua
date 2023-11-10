local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = "\\"

local opt = vim.opt
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.signcolumn = "yes"
opt.spell.spelllang = "en_uk"
opt.sidescroll = 1
opt.sidescrolloff = 3
opt.cursorline = true
opt.undodir = vim.fn.expand('~') .. '/.undodir/'
opt.undofile = true
opt.autochdir = true
vim.cmd("syntax on")
opt.list = true
opt.listchars = "tab:>-"
opt.termguicolors = true

vim.keymap.set("n", "<up>", function() vim.cmd("tabr") end)
vim.keymap.set("n", "<down>", function() vim.cmd("tabl") end)
vim.keymap.set("n", "<right>", function() vim.cmd("tabn") end)
vim.keymap.set("n", "<left>", function() vim.cmd("tabp") end)

require("lazy").setup({
  {
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      config = function()
        require("telescope").setup {
          extensions = {
            file_browser = {
              -- disables netrw and use telescope-file-browser in its place
              hijack_netrw = true,
              mappings = {
                ["n"] = {
                  -- your custom normal mode mappings
                },
                ["i"] = {
                  -- your custom insert mode mappings
                },
              },
            },
          },
        }
        require("telescope").load_extension "file_browser"
        vim.api.nvim_set_keymap(
          "n",
          "<space><space>",
          ":Telescope file_browser initial_mode=normal<CR>",
          { noremap = true }
        )
      end
    },
    {
      'tanvirtin/vgit.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim'
      },
      config = function()
        vim.o.updatetime = 300
        vim.o.incsearch = false
        vim.wo.signcolumn = 'yes'
        require('vgit').setup()
      end
    },
    'christoomey/vim-tmux-navigator',
    'roxma/vim-tmux-clipboard',
    'tmux-plugins/vim-tmux-focus-events',
    'tpope/vim-surround',
    'tpope/vim-commentary',
    {
      'rebelot/kanagawa.nvim',
      config = function()
        vim.cmd("colorscheme kanagawa")
      end
    },
    'tanvirtin/vgit.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      vim.o.updatetime = 300
      vim.o.incsearch = false
      vim.wo.signcolumn = 'yes'
      require('vgit').setup()
    end
  },
  'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  'rust-lang/rust.vim',
  'neovim/nvim-lsp',
  'neovim/nvim-lspconfig',
  {
    'scalameta/nvim-metals',
    ft = { "scala", "sbt", "java" },
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    init = function()
      local metals_config = require("metals").bare_config()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
      }
      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require('telescope.builtin')

      local find_files = function(opts)
        opts = opts or {}
        opts.cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if #vim.lsp.get_active_clients() == 1 and vim.lsp.get_active_clients()[1].config then
          opts.cwd = vim.lsp.get_active_clients()[1].config.root_dir
        end
        builtin.find_files(opts)
      end

      local live_grep = function(opts)
        opts = opts or {}
        opts.cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if #vim.lsp.get_active_clients() == 1 and vim.lsp.get_active_clients()[1].config then
          opts.cwd = vim.lsp.get_active_clients()[1].config.root_dir
        end
        builtin.live_grep(opts)
      end

      vim.keymap.set('n', '<leader>ff', find_files, {})
      vim.keymap.set('n', '<leader>fg', live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      require('telescope').setup {}
      -- open when a directory
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
          local bufname = vim.api.nvim_buf_get_name(0)
          local stats = vim.loop.fs_stat(bufname)
          if stats and stats.type == "directory" then
            require("telescope.builtin").find_files({ search_dirs = { bufname } })
          end
        end
      })
    end
  },
  {
    'folke/trouble.nvim',
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      'nvim-telescope/telescope.nvim'
    },
    init = function()
      local trouble = require("trouble.providers.telescope")
      vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end)
      vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() trouble.toggle("loclist") end)
      vim.keymap.set("n", "gR", function() trouble.toggle("lsp_references") end)
      local actions = require("telescope.actions")

      local telescope = require("telescope")

      telescope.setup {
        defaults = {
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      }
    end
  },
  'vim-test/vim-test',
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (or "all")
        ignore_install = { "javascript" },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

        highlight = {
          enable = true,

          -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.0.0",
    build = "make install_jsregexp"
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      -- Set up nvim-cmp.
      local cmp = require 'cmp'

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        }, {
          { name = 'buffer' },
        })
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })

        lsp_zero.buffer_autoformat()
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
        vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        vim.keymap.set('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
      end)
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
        },
      })
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup({})
    end
  },
})
