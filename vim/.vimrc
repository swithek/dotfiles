""""""""""""""""""""""""""""""""""""""""
"
" => General
"
""""""""""""""""""""""""""""""""""""""""

" Define a leader key.
let mapleader = ","

" Make Vim behave in a more useful way (non Vi-compatible).
set nocompatible

" Set how many lines of history Vim has to remember.
set history=500

" Load plugins by filetype.
filetype plugin indent on

" Auto read when a file is changed from the outside.
set autoread

" Auto write when a file being built (:make).
set autowrite

" Hide mode status info.
set noshowmode

" Set true terminal colors.
set termguicolors

""""""""""""""""""""""""""""""""""""""""
"
" => Plugins
"
""""""""""""""""""""""""""""""""""""""""

" Install vim-plug, if needed.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Update / install Vim plugins.
nnoremap <leader>` :PlugUpdate<cr>

""""""""""""""""""""""""""""""""""""""
" => General purpose plugins
""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } 
Plug 'vim-airline/vim-airline'
Plug 'junegunn/goyo.vim' 
Plug 'junegunn/limelight.vim' 
Plug 'morhetz/gruvbox'
Plug 'cespare/vim-toml'

""""""""""""""""""""""""""""""""""""""
" => Development plugins
""""""""""""""""""""""""""""""""""""""
Plug 'scrooloose/nerdcommenter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

""""""""""""""""""""""""""""""""""""""
" => Writing (prose, etc.) plugins
""""""""""""""""""""""""""""""""""""""
Plug 'reedes/vim-pencil', { 'for': ['markdown', 'text']}
Plug 'kana/vim-textobj-user', { 'for': ['markdown', 'text']}
Plug 'reedes/vim-textobj-quote', { 'for': ['markdown', 'text']}
Plug 'reedes/vim-litecorrect', { 'for': ['markdown', 'text']}
Plug 'reedes/vim-lexical', { 'for': ['markdown', 'text']}
Plug 'reedes/vim-wordy', { 'for': ['markdown', 'text']}
Plug 'dbmrq/vim-ditto', { 'for': ['markdown', 'text']}

call plug#end()

""""""""""""""""""""""""""""""""""""""
" => Undotree
""""""""""""""""""""""""""""""""""""""

" Open / close undo tree view.
nnoremap <leader>u :UndotreeToggle<cr>

""""""""""""""""""""""""""""""""""""""
" => NERDTree
""""""""""""""""""""""""""""""""""""""

" Open file manager on enter.
autocmd VimEnter * NERDTree

" Open / close file manager.
nnoremap <leader>o :NERDTreeToggle<cr>

""""""""""""""""""""""""""""""""""""""
" => vim-airline
""""""""""""""""""""""""""""""""""""""

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#hunks#enabled = 0

""""""""""""""""""""""""""""""""""""""
" Goyo
""""""""""""""""""""""""""""""""""""""

" Toggle focus mode.
nnoremap <silent> <leader>z :Goyo<cr>

""""""""""""""""""""""""""""""""""""""
" => limelight
""""""""""""""""""""""""""""""""""""""

" Set inactive text color.
let g:limelight_conceal_ctermfg = '254'

" Toggle limelight status.
nnoremap <silent> <leader>x :Limelight!!<cr>

""""""""""""""""""""""""""""""""""""""
" => vim-go
""""""""""""""""""""""""""""""""""""""

" Run goimports when using gofmt.
let g:go_fmt_command = "goimports"

" Get signature / type info under the cursor.
let g:go_auto_type_info = 1

" Show the name of each failed test.
let g:go_test_show_name = 1

" Specifiy a tool for signature / type fetching.
let g:go_info_mode = 'gopls'

" Automatically highlight all uses of the indentifier.
let g:go_auto_sameids = 1

" Various syntax objects highlighting.
let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

augroup gobindings
	autocmd! gobindings

	" Generate error checks.
	autocmd FileType go nmap <buffer> <leader>er <Plug>(go-iferr)

	" Add tags to a struct.
	autocmd FileType go nnoremap <buffer> <leader>tg :GoAddTags<cr>

	" Run all package tests.
	autocmd FileType go nmap <buffer> <leader>t <Plug>(go-test)

	" Run only the test that is under the cursor.
	autocmd FileType go nmap <buffer> <leader>tf <Plug>(go-test-func)

	" Toggle code coverage.
	autocmd FileType go nmap <buffer> <leader>k <Plug>(go-coverage-toggle)
augroup end

""""""""""""""""""""""""""""""""""""""
" => vim-lexical
""""""""""""""""""""""""""""""""""""""

let g:lexical#spelllang = ['en_gb']

""""""""""""""""""""""""""""""""""""""""
"
" => Custom modes
"
""""""""""""""""""""""""""""""""""""""""

" Call Prose() to activate prose-specific settings for the active buffer.
fun! Prose()
	setl textwidth=74
	call pencil#init()
	call textobj#quote#init()
	call litecorrect#init()
	call lexical#init()

	" Format paragraph under the cursor.
	nnoremap <buffer> <silent> Q gqap

	" Visually select the whole paragraph under the cursor.
	vnoremap <buffer> <silent> Q ap

	" Format visually selected text.
	vnoremap <buffer> <silent> QQ gq

	" Format all paragraphs in active buffer.
	nnoremap <buffer> <silent> <leader>Q ggVGgq

	" Surround with double curly quotes.
	nmap <buffer> <silent> Sq <Plug>SurroundWithDouble
	vmap <buffer> <silent> Sq <Plug>SurroundWithDouble

	" Surround with single curly quotes.
	nmap <buffer> <silent> SQ <Plug>SurroundWithSingle
	vmap <buffer> <silent> SQ <Plug>SurroundWithSingle

	" Replace straight quotes with curly.
	nmap <buffer> <silent> <leader>qc <Plug>ReplaceWithCurly
	vmap <buffer> <silent> <leader>qc <Plug>ReplaceWithCurly

	" Replace curly quotes with straight.
	nmap <buffer> <silent> <leader>qs <Plug>ReplaceWithStraight
	vmap <buffer> <silent> <leader>qs <Plug>ReplaceWithStraight

	" Cycle through Wordy's categories.
	nnoremap <buffer> <silent> <leader>wo :NextWordy<cr>

	" Disable Wordy.
	nnoremap <buffer> <silent> <leader>wO :NoWordy<cr>

	" Toggle Ditto state.
	nmap <buffer> <silent> <leader>di <Plug>ToggleDitto
endf

" Activate Prose mode automatically.
" autocmd FileType markdown,text call Prose()

" Activate Prose mode manually.
command! -nargs=0 Prose call Prose()

""""""""""""""""""""""""""""""""""""""""
"
" => Vim user interface
"
""""""""""""""""""""""""""""""""""""""""

" Always show status-line.
set laststatus=2

" Set proper formatting.
set formatoptions-=t

" Set what method should be used when inserting folding marks.
set foldmethod=syntax

" Show line numbers.
set number

" Bring love and joy into the world.
set noexpandtab

" Width of the TAB character.
set tabstop=8
set shiftwidth=8
set softtabstop=8

" Display TAB as characters.
set list 
set listchars=tab:>·

" Show possible options when typing in command-line and pressing TAB.
set wildmenu

" Extend regular expressions.
set magic

" Highlight the screen line of the cursor.
set cursorline

" Show the recommended length of line.
set colorcolumn=79

" Do not wrap the lines.
set nowrap

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=15

" Highlight search results.
set hlsearch

" While typing a search command, show where the pattern, as it was typed
" so far, matches.
set incsearch

" Show matching brackets when text indicator is over them.
set showmatch

" Set searches to be case-insensitive.
set ignorecase

" Override the 'ignorecase' option if the search pattern contains upper
" case characters.
set smartcase

" Apply global substitutions on lines.
set gdefault

" Set the character encoding used inside Vim.
set encoding=utf-8

" Enable syntax highlighting.
syntax enable

" Call LightsOut to activate dark theme settings.
fun! LightsOut()
	" contrast must be before colorsheme.
	let g:gruvbox_contrast_dark='hard'
	colorscheme gruvbox
	set background=dark 
	let g:limelight_conceal_ctermfg = '236'
	":AirlineRefresh
endf

" Activate dark theme manually.
command! -nargs=0 LightsOut call LightsOut()

" Call LightsOn to activate light theme settings.
fun! LightsOn()
	" contrast must be before colorsheme.
	let g:gruvbox_contrast_light='hard'
	colorscheme gruvbox
	set background=light
	let g:limelight_conceal_ctermfg = '187'
	":AirlineRefresh
endf

" Activate light theme manually.
command! -nargs=0 LightsOn call LightsOn()

" Activate dark theme by default.
call LightsOut()

" Theme activation shortcuts.
nnoremap <leader>m1 :call LightsOut()<cr>
nnoremap <leader>m2 :call LightsOn()<cr>

""""""""""""""""""""""""""""""""""""""""
"
" => Files, backups and undo
"
""""""""""""""""""""""""""""""""""""""""

" Disable file backups.
set nobackup

" Create a backup before writing to disk (remove after successful write).
set writebackup

" Disable swap files creation.
set noswapfile

" Make Vim store the undo history in a file.
set undofile

" Set undo file location.
set undodir=~/.vim_undo//,.

""""""""""""""""""""""""""""""""""""""""
"
" => Editor key mappings
"
""""""""""""""""""""""""""""""""""""""""

" Reload .vimrc.
nnoremap <leader>rv :source $MYVIMRC<cr>

" Clear out latest search.
nnoremap <leader>/ :noh<cr>

" Go to the matching bracket when pressing TAB.
nmap <tab> %
vmap <tab> %

" Prevent arrows usage in all modes.
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" Go to the next buffer.
noremap <leader>n :bnext<cr>

" Go to the previous buffer.
noremap <leader>p :bprev<cr>

" List all active buffers.
noremap <leader>b :ls<cr>

" Close current buffer.
noremap <leader>c :bd<cr>

" Close all buffers.
noremap <leader>ca :bd<cr>

" Close active window.
noremap <leader><esc> :q<cr>

" Split buffer navigation.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
