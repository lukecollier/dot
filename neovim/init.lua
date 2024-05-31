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
        gradleScript = "/Users/lcolli/Projects/work/df-federated-sql/fedsql/gradlew"
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
      local trouble = require("trouble")
      vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end)
      vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end)
      vim.keymap.set("n", "<leader>xll", function() trouble.toggle("loclist") end)
      vim.keymap.set("n", "<leader>xn", function() trouble.next({ skip_groups = true, jump = true }) end)
      vim.keymap.set("n", "<leader>xp", function() trouble.previous({ skip_groups = true, jump = true }) end)
      vim.keymap.set("n", "<leader>xf", function() trouble.first({ skip_groups = true, jump = true }) end)

      vim.keymap.set("n", "gR", function() trouble.toggle("lsp_references") end)
      local trouble = require("trouble.providers.telescope")
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
        sync_install = true,

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
      vim.filetype.add({ extension = { wgsl = "wgsl" } })

      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.wgsl = {
        install_info = {
          url = "https://github.com/szebniok/tree-sitter-wgsl",
          files = { "src/parser.c" }
        },
      }

      require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "wgsl" },
        highlight = {
          enable = true
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
      }
    end
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.0.0",
    build = "make install_jsregexp",
    config = function()
      local luasnip = require 'luasnip'
      local s = luasnip.snippet
      local sn = luasnip.snippet_node
      local t = luasnip.text_node
      local i = luasnip.insert_node
      local f = luasnip.function_node
      local c = luasnip.choice_node
      local d = luasnip.dynamic_node
      local r = luasnip.restore_node
      local function mimic(args)
        return args[1]
      end
      vim.keymap.set({ "i", "s" }, "<C-L>", function() luasnip.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-H>", function() luasnip.jump(-1) end, { silent = true })

      luasnip.add_snippets("scala", {
        s("fn", {
          t({ "", "def " }),
          i(1),
          t("("),
          i(2, "foo"), t({ ": " }), i(3, "Int"),
          t({ "): " }), i(4, "Int"), t({ "= {", "\t" }),
          i(0),
          t({ "", "}" }),
        }
        )
      })
      luasnip.add_snippets("rust", {
        s("fn", {
          t({ "fn " }),
          i(1),
          t("("),
          i(2, "foo: &str"),
          t({ ") -> " }), i(3, "&str"), t({ " {", "\t" }),
          i(0),
          t({ "", "}" }),
        }),
        s("test", {
          t({ "", "\t#[test]" }),
          t({ "", "\tfn " }), i(1, "example_test"), t({ "() {", "\t" }),
          i(2),
          t({ "", "\t\tassert_eq!(" }), i(0), t({ "2 + 2, 4);" }),
          t({ "", "\t}" }),
        }),
        s("cfgtest", {
          t({ "#[cfg(test)] " }),
          t({ "", "mod tests {" }),
          t({ "", "\tuse super::*;" }),
          t({ "", "\t#[test]" }),
          t({ "", "\tfn " }), i(1, "example_test"), t({ "() {", "\t" }),
          i(2),
          t({ "", "\t\tassert_eq!(" }), i(0), t({ "2 + 2, 4);" }),
          t({ "", "\t}" }),
          t({ "", "}" }),
        })
      }
      )
    end
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
      "github/copilot.vim",
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
          ['<C-g>'] = cmp.mapping(function(fallback)
            vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)),
              'n', true)
          end),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
          ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
          -- ['<C-y>'] = cmp.mapping.complete(),
          ['<C-n>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "copilot",  group_index = 1 },
          { name = 'nvim_lsp', group_index = 1 },
          { name = 'luasnip',  group_index = 1 }, -- For luasnip users.
        }, {
          { name = 'buffer', group_index = 2 },
          { name = 'path',   group_index = 1 },
          -- { name = 'cmdline', group_index = 2 }
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
    "github/copilot.vim",
    tag = 'v1.24.0',
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
      local lsp_configurations = require('lspconfig.configs')
      if not lsp_configurations.plunger then
        lsp_configurations.plunger = {
          default_config = {
            name = 'plunger-lsp',
            cmd = vim.lsp.rpc.connect("127.0.0.1", 8080),
            filetypes = { 'sql' },
            root_dir = require('lspconfig.util').root_pattern('.git')
          }
        }
      end
      require('lspconfig').plunger.setup({})

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
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      -- REQUIRED
      harpoon:setup({
        -- Setting up custom behavior for a list named "cmd"
        cmd = {

          -- When you call list:append() this function is called and the return
          -- value will be put in the list at the end.
          --
          -- which means same behavior for prepend except where in the list the
          -- return value is added
          --
          -- @param possible_value string only passed in when you alter the ui manual
          create_list_item = function(possible_value)
            -- get the current line idx
            local idx = vim.fn.line(".")
            local command = "tmux select-window -t 1"

            local handle = assert(io.popen(command), string.format("unable to execute: [%s]", command))
            local result = handle:read("*a")
            handle:close()


            -- read the current line
            local cmd = vim.cmd('!tmux select-window -t 1')
            if cmd == nil then
              return nil
            end

            return {
              value = result,
              context = {},
            }
          end,

          --- This function gets invoked with the options being passed in from
          --- list:select(index, <...options...>)
          --- @param list_item {value: any, context: any}
          --- @param list { ... }
          --- @param option any
          select = function(list_item, list, option)
            -- WOAH, IS THIS HTMX LEVEL XSS ATTACK??
            vim.cmd(list_item.value)
          end

        }
      })

      vim.keymap.set("n", "<leader>a", function() harpoon:list("cmd"):append() end)

      -- Toggle a harpoon marked

      vim.keymap.set("n", "<C-h>", function() harpoon:list():select(0) end)
      vim.keymap.set("n", "<C-t>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-n>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-s>", function() harpoon:list():select(3) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
        }):find()
      end

      vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list("cmd")) end,
        { desc = "Open harpoon window" })
    end
  }
})
