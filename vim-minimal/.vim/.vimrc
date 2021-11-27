set nocompatible
let mapleader=' '
set termguicolors
filetype plugin indent on
syntax on

" netrw
let g:NetrwIsOpen=0
function! ToggleNetrw()
  if g:NetrwIsOpen
    let i = bufnr('$')
    while (i >= 1)
      if (getbufvar(i, '&filetype') == 'netrw')
        silent exe 'bdelete ' . i
      endif
      let i-=1
    endwhile
    let g:NetrwIsOpen=0
  else
    let g:NetrwIsOpen=1
    silent Lexplore
  endif
endfunction

nnoremap <silent> <leader>e :call ToggleNetrw()<CR>
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup end

set noautochdir " dont auto change dir when open another buffer since we need netrw to open the working directory

function! NetrwMapping()
  nmap <buffer> o <CR>
endfunction

" simple auto-pairs
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
inoremap (      ()<Left>
inoremap [      []<Left>
inoremap '      ''<Left>
inoremap "      ""<Left>
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ')' ? '<Right>' : ')'
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == ']' ? '<Right>' : ']'
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "'" ? '<Right>' : "''<Left>"
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == '"' ? '<Right>' : '""<Left>'

" fuzzy file search
set path+=**
set wildmenu
set wildmode=list:longest
set wildignore+=**/.git/**,**/build/**,**/logs/**
nnoremap <leader>f :find 
nnoremap <C-f> :find 

" tab stuffs
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set listchars=tab:>\ ,trail:~
set list

" line numbers
set number
set relativenumber

" searching
set incsearch
set hlsearch
set ignorecase
set smartcase

" status bar
set laststatus=1
set cmdheight=1
set showmode
set showcmd
set ruler

" cursor
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
else
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif

" useful mappings
map <C-c> <ESC>
imap <C-c> <ESC>
map <silent> <C-c> :nohlsearch<CR>
nnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap B ^
nnoremap E $
nmap Y y$
vmap < <gv
vmap > >gv
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <silent> <C-w><C-h> :vertical resize -2<CR>
nnoremap <silent> <C-w><C-j> :resize -2<CR>
nnoremap <silent> <C-w><C-k> :resize +2<CR>
nnoremap <silent> <C-w><C-l> :vertical resize +2<CR>

" fold
set foldmethod=indent
set foldlevelstart=99

" other
set updatetime=300
set encoding=utf-8
set hidden
set autoread
set autowriteall
set cursorline
set lazyredraw
set showmatch
if !has('nvim')
  set ttymouse=xterm2 " Set this to have smooth mouse selection in tmux
end
set mouse=a
set splitbelow
set splitright
set scrolloff=5
set shortmess-=S " Show number of matches

colorscheme darcula

