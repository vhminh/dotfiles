set nocompatible
let mapleader=' '
set termguicolors

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-sneak'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'preservim/tagbar'
call plug#end()

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

  " \ 'red': { 'gui': '#ff5f87', 'cterm': '204', 'cterm16': '1' },
  " \ 'dark_red': { 'gui': '#be5046', 'cterm': '196', 'cterm16': '9' },
  " \ 'green': { 'gui': '#87d787', 'cterm': '114', 'cterm16': '2' },
  " \ 'yellow': { 'gui': '#d7af87', 'cterm': '180', 'cterm16': '3' },
  " \ 'dark_yellow': { 'gui': '#d7875f', 'cterm': '173', 'cterm16': '11' },
  " \ 'blue': { 'gui': '#00afff', 'cterm': '39', 'cterm16': '4' },
  " \ 'purple': { 'gui': '#d75fd7', 'cterm': '170', 'cterm16': '5' },
  " \ 'cyan': { 'gui': '#56b6c2', 'cterm': '38', 'cterm16': '6' },
  " \ 'white': { 'gui': '#afafaf', 'cterm': '145', 'cterm16': '15' },
  " \ 'black': { 'gui': '#262626', 'cterm': '235', 'cterm16': '0' },
  " \ 'foreground': { 'gui': '#afafaf', 'cterm': '145', 'cterm16': 'NONE' },
  " \ 'background': { 'gui': '#262626', 'cterm': '235', 'cterm16': 'NONE' },
let g:onedark_color_overrides = {
  \ 'black': { 'gui': '#262626', 'cterm': '235', 'cterm16': '0' },
  \ 'background': { 'gui': '#262626', 'cterm': '235', 'cterm16': 'NONE' },
  \ 'comment_grey': { 'gui': '#5f5f5f', 'cterm': '59', 'cterm16': '7' },
  \ 'gutter_fg_grey': { 'gui': '#444444', 'cterm': '238', 'cterm16': '8' },
  \ 'cursor_grey': { 'gui': '#303030', 'cterm': '236', 'cterm16': '0' },
  \ 'visual_grey': { 'gui': '#3a3a3a', 'cterm': '237', 'cterm16': '8' },
  \ 'menu_grey': { 'gui': '#3a3a3a', 'cterm': '237', 'cterm16': '7' },
  \ 'special_grey': { 'gui': '#3b4048', 'cterm': '238', 'cterm16': '7' },
  \ 'vertsplit': { 'gui': '#5f5f5f', 'cterm': '59', 'cterm16': '7' },
  \ }
augroup colorextend
  autocmd!
  let colors = onedark#GetColors()
  autocmd ColorScheme * call onedark#extend_highlight('Keyword', { 'fg': colors.purple })
  autocmd ColorScheme * call onedark#extend_highlight('goDeclType', { 'fg': colors.purple })
augroup end

nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>

if executable('rg')
  function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!{.git,node_modules}" -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!{.git,node_modules}" '.shellescape(<q-args>), 1, <bang>0)
  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden -g "!{.git,node_modules}"'
  nnoremap <silent> <leader>g :RG<CR>
elseif executable('ag')
  nnoremap <silent> <leader>g :Ag<CR>
endif

let $BAT_THEME = 'TwoDark'

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

set noautochdir

function! NetrwMapping()
  nmap <buffer> o <CR>
endfunction

let g:sneak#label = 1
let g:sneak#prompt = '> '
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

augroup sneak_highlight
  autocmd!
  let colors = onedark#GetColors()
  let background_color = has_key(colors, 'background') ? colors.background : colors.black
  autocmd ColorScheme * execute 'highlight Sneak guifg=' background_color.gui 'guibg=' colors.yellow.gui 'ctermfg=' background_color.cterm 'ctermbg=' colors.yellow.cterm
  autocmd ColorScheme * execute 'highlight SneakLabel guifg=' background_color.gui 'guibg=' colors.yellow.gui 'ctermfg=' background_color.cterm 'ctermbg=' colors.yellow.cterm
augroup end

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
else
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif

if executable('ctags')
  nnoremap <silent> <C-t> :TagbarToggle<CR>
  nnoremap <silent> <leader>t :TagbarToggle<CR>
endif

set statusline=%!StatusLine()
function! StatusLine()
  let result = '%#Visual# ' .. mode(1) .. ' %*' .. ' %t %y %m%< %r %h %w%=%l / %L [%{&fileencoding?&fileencoding:&encoding}] [%{&fileformat}] '
  let [a,m,r] = GitGutterGetHunkSummary()
  if a + m + r > 0
    let result = result . printf('%%#GitGutterAdd#+%d %%#GitGutterChange#~%d %%#GitGutterDelete#-%d', a, m, r) . ' '
  endif
  return result
endfunction

set noshowmode
set noruler

set laststatus=2
set noshowcmd
set cmdheight=1

autocmd BufWritePost * GitGutter
let g:gitgutter_map_keys = 1
let g:gitgutter_preview_win_floating = 1


filetype plugin indent on

set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set listchars=tab:»\ ,trail:~
set list

set number
set relativenumber

set incsearch
set hlsearch
set ignorecase
set smartcase

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

set foldmethod=indent
set foldlevelstart=99

set updatetime=300
set encoding=utf-8
set wildmenu
set wildmode=list:longest
set autoread
set autowriteall
set cursorline
set lazyredraw
set showmatch
set mouse=a
set splitbelow
set splitright
set scrolloff=5
set shortmess-=S " show number of matches

colorscheme onedark

