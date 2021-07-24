set nocompatible
let mapleader=" "


""""""""""""""""""""""""""""""""""""""""""""""
" VIM PLUG                                   "
""""""""""""""""""""""""""""""""""""""""""""""
" auto install vimplug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif 
" plugins
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
if executable('ctags')
  Plug 'preservim/tagbar'
end
call plug#end()
" auto install missing plugin
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


""""""""""""""""""""""""""""""""""""""""""""""
" ONE DARK                                   "
""""""""""""""""""""""""""""""""""""""""""""""
syntax on
colorscheme onedark


""""""""""""""""""""""""""""""""""""""""""""""
" FZF                                        "
""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-f> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden -g "!{.git,node_modules}"'
end


""""""""""""""""""""""""""""""""""""""""""""""
" NETRW                                      "
""""""""""""""""""""""""""""""""""""""""""""""
let g:NetrwIsOpen=0
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bdelete " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction
nnoremap <C-n> :call ToggleNetrw()<CR>
nnoremap <leader>n :call ToggleNetrw()<CR>
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    nmap <buffer> o <CR>
endfunction


""""""""""""""""""""""""""""""""""""""""""""""
" TAGBAR                                     "
""""""""""""""""""""""""""""""""""""""""""""""
if executable('ctags')
  nnoremap <C-t> :TagbarToggle<CR>
  nnoremap <leader>t :TagbarToggle<CR>
end


""""""""""""""""""""""""""""""""""""""""""""""
" OTHER                                      "
""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on

" tab stuffs
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set listchars=tab:>·,trail:~
set list

" line numbers
set number
set relativenumber

" searching
set incsearch
set hlsearch
set ignorecase
set smartcase

" useful mappings
map <C-c> <ESC>
map! <C-c> <ESC>
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $
nmap Y y$
vmap < <gv
vmap > >gv
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-w><C-h> :vertical resize -2<CR>
nnoremap <C-w><C-j> :resize -2<CR>
nnoremap <C-w><C-k> :resize +2<CR>
nnoremap <C-w><C-l> :vertical resize +2<CR>

" fold
set foldmethod=indent
set foldlevelstart=99

" other
set autoread
set autowriteall
set autochdir
set cursorline
set lazyredraw
set showmatch
set mouse=a
set splitbelow
set splitright
set scrolloff=5

" Statusline stuffs
if has('nvim')
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
    set noshowmode
endif
set noruler

set laststatus=1
set noshowcmd
set cmdheight=1

