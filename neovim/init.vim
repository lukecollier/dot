
" --------------------------------------------------------------------------------
" - Plugins                                                                      -
" --------------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" Nvim files
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'rust-lang/rust.vim'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'scalameta/nvim-metals'
Plug 'nvim-telescope/telescope.nvim'
Plug 'vim-test/vim-test'

Plug 'norcalli/snippets.nvim'
" lsp
Plug 'folke/trouble.nvim' " dap
Plug 'mfussenegger/nvim-dap'
Plug 'kosayoda/nvim-lightbulb'

" Tmux linking plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Scala
Plug 'derekwyatt/vim-scala'

" Theme
Plug 'sonph/onehalf', {'rtp': 'vim/'}

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-rhubarb'

" Reason
Plug 'reasonml-editor/vim-reason-plus'

" Distraction free
Plug 'junegunn/goyo.vim'

" God pope
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-projectionist'

" Jsonnet
Plug 'google/vim-jsonnet'

" God junegunn
Plug 'Yggdroot/indentLine'
Plug 'junegunn/vim-peekaboo'
" NNN
Plug 'mcchrish/nnn.vim'

Plug 'dhruvasagar/vim-table-mode'


call plug#end()

let g:rust_clip_command = 'pbcopy'

" --------------------------------------------------------------------------------
" - Language Client                                                              -
" --------------------------------------------------------------------------------

let g:metals_server_version = '0.11.2'

" --------------------------------------------------------------------------------
" - Lua Setup                                                              -
" --------------------------------------------------------------------------------

lua <<EOF
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = { 'metals', 'rust_analyzer', 'tsserver' }
  for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
      on_attach = on_attach,
      flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
        }
      }
  end
  vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

  require("trouble").setup {
    {
      position = "bottom", -- position of the list can be: bottom, top, left, right
      height = 10, -- height of the trouble list when position is top or bottom
      width = 50, -- width of the list when position is left or right
      icons = true, -- use devicons for filenames
      mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
      fold_open = "", -- icon used for open folds
      fold_closed = "", -- icon used for closed folds
      action_keys = { -- key mappings for actions in the trouble list
      -- map to {} to remove a mapping, for example:
      -- close = {},
      close = "q", -- close the list
      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
      refresh = "r", -- manually refresh
      jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
      open_split = { "<c-x>" }, -- open buffer in new split
      open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
      open_tab = { "<c-t>" }, -- open buffer in new tab
      jump_close = {"o"}, -- jump to the diagnostic and close the list
      toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
      toggle_preview = "P", -- toggle auto_preview
      hover = "K", -- opens a small poup with the full multiline message
      preview = "p", -- preview the diagnostic location
      close_folds = {"zM", "zm"}, -- close all folds
      open_folds = {"zR", "zr"}, -- open all folds
      toggle_fold = {"zA", "za"}, -- toggle fold of current file
      previous = "k", -- preview item
      next = "j" -- next item
      },
      indent_lines = true, -- add an indent guide below the fold icons
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false, -- automatically fold a file trouble list at creation
      signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
      },
      use_lsp_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    };
  }

  local snippets = require'snippets'
  local U = require'snippets.utils'
  snippets.snippets = {
    _global = {
      note = U.force_comment [[NOTE: ]];
      todo = U.force_comment [[TODO: ]];
      date = os.date;
    };
  }

EOF

au BufWritePre *.scala :lua vim.lsp.buf.formatting()
au BufWritePre *.rs :lua vim.lsp.buf.formatting()

" --------------------------------------------------------------------------------
" - Autocomplete                                                                 -
" --------------------------------------------------------------------------------

" https://github.com/nvim-lua/completion-nvim#enable-snippets-support
let g:completion_enable_snippet = 'snippets.nvim'
lua require'snippets'.use_suggested_mappings()
" inoremap <c-k> <cmd>lua return require'snippets'.expand_or_advance(1)<CR>

" " <c-j> will jump backwards to the previous field.
" " If you jump before the first field, it will cancel the snippet.
" inoremap <c-j> <cmd>lua return require'snippets'.advance_snippet(-1)<CR>
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

set completeopt=menuone,noinsert,noselect

set shortmess+=c

set belloff+=ctrlg 

" --------------------------------------------------------------------------------
" - Fuzzy Search                                                                 -
" --------------------------------------------------------------------------------

let g:picker_custom_find_executable = 'rg'
let g:picker_custom_find_flags = '--files'

let g:picker_selector_executable = 'fzy'
let g:picker_selector_flags = ''

" --------------------------------------------------------------------------------
" - Goyo Set-up                                                                    -
" --------------------------------------------------------------------------------
let g:goyo_height="100%"
let g:goyo_width="100%"

function! s:goyo_enter()
    if executable('tmux') && strlen($TMUX)
        silent !tmux set status off
        silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    endif
    set noshowmode
    set noshowcmd
    " ...
endfunction

function! s:goyo_leave()
    if executable('tmux') && strlen($TMUX)
        silent !tmux set status on
        silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    endif
    set showmode
    set showcmd
    " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" --------------------------------------------------------------------------------
" - Vim Set-up                                                                    -
" --------------------------------------------------------------------------------
"
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>

nnoremap <leader>c :NnnPicker %:p:h<CR>
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
au VimEnter * if argc() == 0 && !exists("s:std_in") | :NnnPicker %:p:h | endif

" Scala lsp setup
" autocmd Filetype scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
" Scala filetype
au BufRead,BufNewFile *.sbt set filetype=scala
au BufRead,BufNewFile *.yml set filetype=yaml
au BufRead,BufNewFile *.yaml set filetype=yaml
au BufRead,BufNewFile *.re set filetype=reason


" --------------------------------------------------------------------------------
" - Vim Set-up                                                                    -
" --------------------------------------------------------------------------------

filetype plugin indent on
" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab
" Gutter on the left
set signcolumn=yes

" Tabbing
map <up> :tabr<cr>
map <down> :tabl<cr>
map <left> :tabp<cr>
map <right> :tabn<cr>

" Spellcheck
set spell spelllang=en_us


syntax on
set t_Co=256
set cursorline
colorscheme onehalfdark

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Make e and E bit more sound
set sidescroll=1
set sidescrolloff=3

" Enable persistent undo
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

let g:table_mode_corner='|'

" Show tabs
set list
set listchars=tab:>-
