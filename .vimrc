
" ---------------------------------
" Installing and activating plugins
" ---------------------------------

" plugins managed by vim-plug
call plug#begin('~/.vim/plugged')

" Autoloaded plugins
Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'itchyny/vim-gitbranch'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" On-demand plugins
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

call plug#end()

" ---------------
" Plugin settings
" ---------------

" lightline settings:

" Specify lightline look
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" vim-go settings:

" Run goimports when using gofmt
let g:go_fmt_command = "goimports"

" Get signature / type info under the cursor
let g:go_auto_type_info = 1

" Show the name of each failed test
let g:go_test_show_name = 1

" Specifiy tool for signature / type fetching
let g:go_info_mode = 'gopls'

" Automatically highlight all uses of the indentifier
let g:go_auto_sameids = 1

" Various syntax highlighting 
let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" ----------------
" Editor settings
" ----------------

" Set what method should be used when inserting folding marks
set foldmethod=syntax

" Make Vim behave in a more useful way (non Vi-compatible) 
set nocompatible

" Set the character encoding used inside Vim
set encoding=utf-8

" Always show status-line
set laststatus=2

" Auto read when a file is changed from the outside
set autoread

" Auto write when a file being built (:make)
set autowrite

" Show line numbers
set number

" Highlight search results
set hlsearch

" While typing a search command, show where the pattern, as it was typed
" so far, matches
set incsearch

" Show matching brackets when text indicator is over them
set showmatch

" Show possible options when typing in command-line and pressing TAB
set wildmenu

" Width of the TAB character
set tabstop=8

" Display TAB as characters
set list 
set listchars=tab:>·

" Highlight the screen line of the cursor
set cursorline

" Show the recommended length of line
set colorcolumn=100

" Don not wrap the lines
set nowrap

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=15

" Set searches to be case-insensitive
set ignorecase

" Override the 'ignorecase' option if the search pattern contains upper
" case characters
set smartcase

" Apply global substitutions on lines
set gdefault

" Enable syntax highlighting
syntax enable

" Setting dark mode
set background=dark

" Setup colorsheme
colorscheme gruvbox

" Open file manager on enter
autocmd VimEnter * NERDTree

" ------------------
" Editor keybindings
" ------------------

" Define leader key
let mapleader = ","

" Clear out a search
nnoremap <leader>/ :noh<cr>

" Go to the matching bracket when pressing TAB
nnoremap <tab> %
vnoremap <tab> %

" Prevent arrows usage in normal / insert modes
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Open file manager
noremap <leader>o :NERDTreeToggle<cr>

" Go to the next buffer
noremap <leader>n :bnext<cr>

" Go to the previous buffer
noremap <leader>p :bprev<cr>

" List all active buffers
noremap <leader>b :ls<cr>

" Close current buffer
noremap <leader>c :bd<cr>

" Close active window
noremap <leader><esc> :q<cr>

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Reload .vimrc
nnoremap <leader>rv :source $MYVIMRC<cr>

" Golang keybindings
augroup gobindings
	autocmd! gobindings
	autocmd Filetype go nmap <buffer> <leader>er <Plug>(go-iferr)
	autocmd Filetype go nnoremap <buffer> <leader>tg :GoAddTags<cr>
	autocmd Filetype go nmap <buffer> <leader>t <Plug>(go-test)
	autocmd Filetype go nmap <buffer> <leader>tf <Plug>(go-test-func)
	autocmd Filetype go nmap <buffer> <leader>a <Plug>(go-alternate-edit)
	autocmd Filetype go nmap <buffer> <leader>k <Plug>(go-coverage-toggle)
augroup end


