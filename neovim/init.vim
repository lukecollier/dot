" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" visual plugins
Plug 'sheerun/vim-wombat-scheme'
" Show parameter doc.
Plug 'Shougo/echodoc.vim'

"Search
Plug 'wincent/ferret'

" editorconfig
Plug 'editorconfig/editorconfig-vim'

" Dev icons
Plug 'ryanoasis/vim-devicons'

" Or, if using Vim-Plug
Plug 'reasonml-editor/vim-reason-plus'

" Coment out yo
Plug 'tpope/vim-commentary'

" Linter
Plug 'w0rp/ale'

" elixir plugins
Plug 'slashmili/alchemist.vim', {'for': 'elixir'}
Plug 'elixir-lang/vim-elixir', {'for': 'elixir'}
Plug 'mattreduce/vim-mix', {'for': 'elixir'}

" Rust plugins
Plug 'sebastianmarkow/deoplete-rust', {'for': 'rust'}

" Elm plugins
Plug 'elmcast/elm-vim', {'for': 'elm'}
Plug 'pbogut/deoplete-elm', {'for': 'elm'}

" Scala
Plug 'derekwyatt/vim-scala', {'for': 'scala'}

" Kotlin
Plug 'udalov/kotlin-vim', {'for': 'kotlin'}

" functionality plugins
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug '/usr/local/opt/fzf'
Plug 'mbbill/undotree'
Plug 'tpope/vim-surround'

" Git
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'

" Tmux linking plugins
Plug 'christoomey/vim-tmux-navigator'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Distraction free
Plug 'junegunn/goyo.vim'

" Language client
Plug 'natebosch/vim-lsc'

" Tsx
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'

" Numbers
Plug 'myusuf3/numbers.vim'

" End plug system
call plug#end()

" Enable deoplete (my favourite autocomplete)
let g:deoplete#enable_at_startup = 1

" Enable persistent undo
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

" File Types
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

" Vim stuff
syntax on
filetype plugin indent on
set hlsearch
set smartcase
set number
set relativenumber
set cursorline
set t_Co=256
if has("nvim")
  set termguicolors
endif 
colorscheme wombat


" Ale (linter)
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_column_always = 1
let g:ale_lint_on_enter = 1
let g:ale_sign_error = 'X'
let g:ale_sign_warning = '!'
let g:ale_echo_msg_error_str = ''
let g:ale_echo_msg_warning_str = ''
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

set hidden
set foldmethod=syntax
set foldlevelstart=20

" Language server
let g:lsc_enable_autocomplete = v:false
let g:lsc_server_commands = {
    \ 'reason': 'ocaml-language-server --stdio',
    \ 'scala': 'metals-vim',
    \ 'ocaml': 'ocaml-language-server --stdio',
    \ 'javascript': 'javascript-typescript-stdio',
    \ 'typescript': 'javascript-typescript-stdio',
    \ 'rust': '~/.cargo/bin/rustup run nigthly rls',
    \ 'python': '/usr/local/bin/pyls',
    \ 'scss': 'css-languageserver --stdio',
    \ 'css': 'css-languageserver --stdio',
    \ }

" language server defaults are:
let g:lsc_auto_map = {
    \ 'GoToDefinition': '<C-]>',
    \ 'FindReferences': 'gr',
    \ 'NextReference': '<C-n>',
    \ 'PreviousReference': '<C-p>',
    \ 'FindImplementations': 'gI',
    \ 'FindCodeActions': 'ga',
    \ 'DocumentSymbol': 'go',
    \ 'WorkspaceSymbol': 'gS',
    \ 'ShowHover': 'v:true',
    \ 'SignatureHelp': '<C-m>',
    \ 'Completion': 'completefunc',
    \}

" Nerd Tree Git Symbols
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "",
    \ "Staged"    : "",
    \ "Untracked" : "",
    \ "Renamed"   : "",
    \ "Unmerged"  : "",
    \ "Deleted"   : "",
    \ "Dirty"     : "",
    \ "Clean"     : "",
    \ 'Ignored'   : '',
    \ "Unknown"   : ""
    \ }

" have a colour column
let &colorcolumn=join(range(92,200),",")

" Dev icons extentions
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ex'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['exs'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pot'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['lock'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['re'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['conf'] = ''

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Nerd tree bindings
map <C-n> :NERDTreeToggle<CR>
map <F5> :UndotreeToggle<cr>
nmap <F8> :TagbarToggle<CR>

" Always draw the signcolumn.
set signcolumn=yes
set cmdheight=2

" Indentation
filetype plugin indent on
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

let g:elm_format_autosave = 0

" make e and E bit more sound
set sidescroll=1
set sidescrolloff=3

" Preview replacement commands live
:set inccommand=nosplit

" For gbrowse in gitlab
let g:fugitive_gitlab_domains = ['https://scm.server.traveljigsaw.com']
