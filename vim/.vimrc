set nocompatible
let mapleader=" "
set termguicolors

let enable_coc = 0
let enable_coc = enable_coc && !has('nvim-0.5')

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
Plug 'tpope/vim-vinegar'
Plug 'justinmk/vim-sneak'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
if executable('ctags')
  Plug 'preservim/tagbar'
endif
Plug 'tpope/vim-commentary'
if has('nvim-0.5')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/completion-nvim'
elseif enable_coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
Plug 'sheerun/vim-polyglot'
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
" Use cterm color for gui (except for special_grey)
let g:onedark_color_overrides = {
  \ 'red': { 'gui': '#ff5f87', 'cterm': '204', 'cterm16': '1' },
  \ 'dark_red': { 'gui': '#ff0000', 'cterm': '196', 'cterm16': '9' },
  \ 'green': { 'gui': '#87d787', 'cterm': '114', 'cterm16': '2' },
  \ 'yellow': { 'gui': '#d7af87', 'cterm': '180', 'cterm16': '3' },
  \ 'dark_yellow': { 'gui': '#d7875f', 'cterm': '173', 'cterm16': '11' },
  \ 'blue': { 'gui': '#00afff', 'cterm': '39', 'cterm16': '4' },
  \ 'purple': { 'gui': '#d75fd7', 'cterm': '170', 'cterm16': '5' },
  \ 'cyan': { 'gui': '#00afd7', 'cterm': '38', 'cterm16': '6' },
  \ 'white': { 'gui': '#afafaf', 'cterm': '145', 'cterm16': '15' },
  \ 'black': { 'gui': '#262626', 'cterm': '235', 'cterm16': '0' },
  \ 'foreground': { 'gui': '#afafaf', 'cterm': '145', 'cterm16': 'NONE' },
  \ 'background': { 'gui': '#262626', 'cterm': '235', 'cterm16': 'NONE' },
  \ 'comment_grey': { 'gui': '#5f5f5f', 'cterm': '59', 'cterm16': '7' },
  \ 'gutter_fg_grey': { 'gui': '#444444', 'cterm': '238', 'cterm16': '8' },
  \ 'cursor_grey': { 'gui': '#303030', 'cterm': '236', 'cterm16': '0' },
  \ 'visual_grey': { 'gui': '#3a3a3a', 'cterm': '237', 'cterm16': '8' },
  \ 'menu_grey': { 'gui': '#3a3a3a', 'cterm': '237', 'cterm16': '7' },
  \ 'special_grey': { 'gui': '#3b4048', 'cterm': '238', 'cterm16': '7' },
  \ 'vertsplit': { 'gui': '#5f5f5f', 'cterm': '59', 'cterm16': '7' },
  \ }


""""""""""""""""""""""""""""""""""""""""""""""
" FZF                                        "
""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-f> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>

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
  nnoremap <leader>g :RG<CR>
elseif executable('ag')
  nnoremap <leader>g :Ag<CR>
endif


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
nnoremap <leader>e :call ToggleNetrw()<CR>
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup end

" Dont auto change dir when open another buffer
" since we need netrw to open the working directory
set noautochdir

function! NetrwMapping()
  nmap <buffer> o <CR>
endfunction


""""""""""""""""""""""""""""""""""""""""""""""
" SNEAK                                      "
""""""""""""""""""""""""""""""""""""""""""""""
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


""""""""""""""""""""""""""""""""""""""""""""""
" CURSOR                                     "
""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
else
  let &t_SI = "\e[6 q"
  let &t_SR = "\e[4 q"
  let &t_EI = "\e[2 q"
endif


""""""""""""""""""""""""""""""""""""""""""""""
" TAGBAR                                     "
""""""""""""""""""""""""""""""""""""""""""""""
if executable('ctags')
  nnoremap <C-t> :TagbarToggle<CR>
  nnoremap <leader>t :TagbarToggle<CR>
endif


""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE                                "
""""""""""""""""""""""""""""""""""""""""""""""
function! StatusLineSetHighlightGroup()
  let colors = onedark#GetColors()
  let stl_color_active = {
    \ 'guibg': synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui'),
    \ 'ctermbg': synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'cterm'),
    \ 'guifg': synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'gui'),
    \ 'ctermfg': synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'cterm'),
    \ }
  execute 'highlight' 'StatusLineHighlightRed'  'guibg=' colors.red.gui 'ctermbg=' colors.red.cterm  'guifg=' stl_color_active.guibg 'ctermfg=' stl_color_active.ctermbg
  execute 'highlight' 'StatusLineHighlightGreen' 'guibg=' colors.green.gui 'ctermbg=' colors.green.cterm 'guifg=' stl_color_active.guibg 'ctermfg=' stl_color_active.ctermbg
  execute 'highlight' 'StatusLineHighlightBlue' 'guibg=' colors.blue.gui 'ctermbg=' colors.blue.cterm 'guifg=' stl_color_active.guibg 'ctermfg=' stl_color_active.ctermbg
  execute 'highlight' 'StatusLineHighlightYellow' 'guibg=' colors.yellow.gui 'ctermbg=' colors.yellow.cterm 'guifg=' stl_color_active.guibg 'ctermfg=' stl_color_active.ctermbg
  execute 'highlight' 'StatusLineHighlightPurple' 'guibg=' colors.purple.gui 'ctermbg=' colors.purple.cterm 'guifg=' stl_color_active.guibg 'ctermfg=' stl_color_active.ctermbg
  execute 'highlight' 'StatusLineHighlightGray' 'guibg=' colors.special_grey.gui 'ctermbg=' colors.special_grey.cterm 'guifg=' stl_color_active.guibg 'ctermfg=' stl_color_active.ctermbg
  execute 'highlight' 'StatusLineHighlightGitBranchActive' 'guibg=' stl_color_active.guibg 'ctermbg=' stl_color_active.ctermbg 'guifg=' colors.purple.gui 'ctermfg=' colors.purple.cterm
  execute 'highlight' 'StatusLineHighlightGitAdd' 'guibg=' stl_color_active.guibg 'ctermbg=' stl_color_active.ctermbg 'guifg=' colors.green.gui 'ctermfg=' colors.green.cterm
  execute 'highlight' 'StatusLineHighlightGitChange' 'guibg=' stl_color_active.guibg 'ctermbg=' stl_color_active.ctermbg 'guifg=' colors.yellow.gui 'ctermfg=' colors.yellow.cterm
  execute 'highlight' 'StatusLineHighlightGitDelete' 'guibg=' stl_color_active.guibg 'ctermbg=' stl_color_active.ctermbg 'guifg=' colors.red.gui 'ctermfg=' colors.red.cterm
endfunction

augroup stl_hi_colors
  autocmd!
  autocmd ColorScheme * call StatusLineSetHighlightGroup()
augroup end

let g:name_by_mode = {
  \ 'n': 'NORMAL',
  \ 'v': 'VISUAL',
  \ 'V': 'V-LINE',
  \ '': 'V-BLOCK',
  \ 's': 'SELECT',
  \ 'S': 'S-LINE',
  \ '': 'S_BLOCK',
  \ 'i': 'INSERT',
  \ 'R': 'REPLACE',
  \ 'c': 'COMMAND',
  \ 'r': 'ENTER?',
  \ '!': 'SHELL',
  \ 't': 'TERM',
  \}

let g:color_by_mode = {
  \ 'n': 'Blue',
  \ 'v': 'Yellow',
  \ 'V': 'Yellow',
  \ '': 'Yellow',
  \ 's': 'Yellow',
  \ 'S': 'Yellow',
  \ '': 'Yellow',
  \ 'i': 'Green',
  \ 'R': 'Red',
  \}

augroup sl_active
  autocmd!
  autocmd WinEnter * setlocal statusline=%!StatusLine(1)
  autocmd VimEnter * setlocal statusline=%!StatusLine(1)
  autocmd BufWinEnter * setlocal statusline=%!StatusLine(1)
  autocmd WinLeave * setlocal statusline=%!StatusLine(0)
augroup end

augroup sl_git_branch
  autocmd!
  autocmd WinEnter * let w:git_branch = GetGitBranch()
  autocmd VimEnter * let w:git_branch = GetGitBranch()
  autocmd BufWinEnter * let w:git_branch = GetGitBranch()
augroup end

function! StatusLineMode(is_active)
  if !a:is_active
    return '%#StatusLineHighlightGray# INACTIVE %*'
  endif
  let m = mode(1)
  let color = has_key(g:color_by_mode, m) ? get(g:color_by_mode, m) : 'Purple'
  return '%#StatusLineHighlight' . color . '# ' . get(g:name_by_mode, m, 'UNKNOWN') . ' %*'
endfunction

function! GetGitBranch()
  if !executable('git')
    " Git not installed
    return ''
  endif
  silent! exe 'git rev-parse --is-inside-work-tree &>/dev/null'
  if v:shell_error != 0
    " Not inside a git repo
    return ''
  endif
  return system('git symbolic-ref --short HEAD')
endfunction

function! StatusLineGitBranch()
  if !exists('w:git_branch')
    let w:git_branch = GetGitBranch()
  endif
  return w:git_branch
endfunction

function! StatusLine(is_active)
  let result = StatusLineMode(a:is_active) . ' %t %y %m%< %r %h %w%=Current: %-5l Total: %-5L'
  if a:is_active
    let result = result . '%#StatusLineHighlightGitBranchActive# ' . StatusLineGitBranch() . '  '
  else
    let result = result . '%#StatusLineNC# ' . StatusLineGitBranch() . '  '
  endif
  let [a,m,r] = GitGutterGetHunkSummary()
  if a + m + r > 0
    if a:is_active
      let result = result . printf('%%#StatusLineHighlightGitAdd#+%d %%#StatusLineHighlightGitChange#~%d %%#StatusLineHighlightGitDelete#-%d', a, m, r) . ' '
    else
      let result = result . printf('%%#StatusLineNC#+%d %%#StatusLineNC#~%d %%#StatusLineNC#-%d', a, m, r) . ' '
    endif
  endif
  return result
endfunction

set noshowmode
set noruler

set laststatus=2
set noshowcmd
set cmdheight=1


""""""""""""""""""""""""""""""""""""""""""""""
" GIT GUTTER                                 "
""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufWritePost * GitGutter
let g:gitgutter_map_keys = 1


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
imap <C-c> <ESC>
map <C-c> :nohlsearch<CR>
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
set updatetime=500
set wildmenu
set wildmode=list:longest
set autoread
set autowriteall
set cursorline
set lazyredraw
set showmatch
set ttymouse=xterm2 " Set this to have smooth mouse selection in tmux
set mouse=a
set splitbelow
set splitright
set scrolloff=5

colorscheme onedark


""""""""""""""""""""""""""""""""""""""""""""""
" NVIM BUILTIN LSP                           "
""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim-0.5')
  set completeopt=menuone,noinsert,noselect
  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

  lua require'lspconfig'.gopls.setup{on_attach=require'completion'.on_attach}
  lua require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
  lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}

  nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> K  <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
  nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
  nnoremap <silent> <leader>ca <cmd>lua print(vim.inspect(vim.lsp.buf.code_action()))<CR>

  nnoremap <silent> <C-LeftMouse> <LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> <RightMouse> <LeftMouse><cmd>lua vim.inspect(vim.lsp.buf.code_action())<CR>
endif






if !enable_coc
  finish
endif
""""""""""""""""""""""""""""""""""""""""""""""
" COC STUFFS                                 "
""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_disable_startup_warning = 1
" copy-paste from
" https://github.com/neoclide/coc.nvim#example-vim-configuration
" with some modification

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)

augroup coc_sth_group
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Show all diagnostics.
nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>s  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>

