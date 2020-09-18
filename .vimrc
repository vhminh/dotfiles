" Dependencies:
" ctags
" Fira Mono font
"
"

set nocompatible

" Vim plug
let need_to_install_plugins = 0
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	"autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	let need_to_install_plugins = 1
endif

call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
" Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'joshdick/onedark.vim'
Plug 'preservim/tagbar'
call plug#end()

filetype plugin indent on
syntax on

" Install plugins
if need_to_install_plugins == 1
	echo "Installing plugins..."
	silent! PlugInstall
	echo "Done!"
	q
endif

" Vim lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
set laststatus=2

" One dark theme
colorscheme onedark

" Set font when running Gvim
if has("gui_running")
	set guifont=Fira\ Mono\ Medium\ 12
endif

" Set up Clang format
"autocmd FileType h,c,cc,java,hpp,cpp,js nnoremap <C-F> :!clang-format -i -style="{BasedOnStyle: Google, IndentWidth: 4, AccessModifierOffset: -2, UseTab: ForIndentation, TabWidth: 4, DerivePointerAlignment: false, PointerAlignment: Left}" %:p <CR><CR> 

" Cancel highlight search when pressing esc twice
nnoremap <Esc><Esc> :nohlsearch<CR>

" Set up folding
syntax on
set foldmethod=indent
set foldlevelstart=99

" Copy and paste from clipboard
set clipboard=unnamedplus

" Set split direction
set splitbelow
set splitright

" Map j k key to up down navigation in visual line (when working with long
" lines)
nnoremap k gk
nnoremap j gj

" Move between panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 2 space tab in javascript
autocmd FileType javascript setlocal ts=2 sts=2 sw=2
" Expand tab to space for python files
autocmd FileType python setlocal expandtab

" Display whitespaces
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set nolist

"" indent/unindent with tab/shift-tab
"nmap <Tab> >>
"vmap <Tab> >>
"imap <S-Tab> <Esc><<i
"nmap <S-tab> <<
"vmap <S-tab> <<

" NerdTree 
map <C-n> :NERDTreeToggle<CR>

" Tagbar
nmap <C-t> :TagbarToggle<CR>

" Fzf
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :Files<CR>

" Other
set showmatch        " Dont know what this is
set autoread         " Auto reload file from disk after running command
set autowrite        " Auto save file
set ignorecase       " Ignore case when search
set smartcase        " Smart case when search
set hlsearch         " Highlight search results
set incsearch        " Jump to search result as we type
set mouse=a          " Enable mouse
set noexpandtab      " Don't expand tab to spaces
set shiftwidth=4     " Shiftwidth indent with >>
set tabstop=4        " Tab size when render
set scrolloff=5      " Scroll offset
set number           " Enable number
set relativenumber   " Enable relative number

