set nocompatible
let mapleader=' '
set termguicolors

let enable_coc = 1
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
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'rafamadriz/friendly-snippets'
else
  if enable_coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'antoinemadec/coc-fzf'
  endif
  Plug 'sheerun/vim-polyglot'
endif
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
" Use cterm color for gui (except for dark_red and special_grey)
let g:onedark_color_overrides = {
  \ 'red': { 'gui': '#ff5f87', 'cterm': '204', 'cterm16': '1' },
  \ 'dark_red': { 'gui': '#be5046', 'cterm': '196', 'cterm16': '9' },
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
augroup colorextend
  autocmd!
  let colors = onedark#GetColors()
  autocmd ColorScheme * call onedark#extend_highlight('Keyword', { 'fg': colors.purple })
augroup end


""""""""""""""""""""""""""""""""""""""""""""""
" FZF                                        "
""""""""""""""""""""""""""""""""""""""""""""""
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

" settings for bat
let $BAT_THEME = 'TwoDark'


""""""""""""""""""""""""""""""""""""""""""""""
" NETRW                                      "
""""""""""""""""""""""""""""""""""""""""""""""
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
  nnoremap <silent> <C-t> :TagbarToggle<CR>
  nnoremap <silent> <leader>t :TagbarToggle<CR>
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
  let result = StatusLineMode(a:is_active) . ' %t %y %m%< %r %h %w%=%l / %L [%{&fileencoding?&fileencoding:&encoding}] [%{&fileformat}] '
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
let g:gitgutter_preview_win_floating = 1


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
set listchars=tab:»\ ,trail:~
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
set wildmenu
set wildmode=list:longest
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

colorscheme onedark


""""""""""""""""""""""""""""""""""""""""""""""
" LSP, SYNTAX HIGHLIGHTING, AND SNIPPETS     "
""""""""""""""""""""""""""""""""""""""""""""""
if has('nvim-0.5')
  " completion
  set completeopt=menuone,noinsert,noselect
  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
  let g:completion_trigger_on_delete = 1
  lua <<EOF
  local cmp = require('cmp')
  cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'vsnip' },
      { name = 'buffer' },
    },
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      })
    },
    snippet = {
      expand = function (args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
  })
EOF

  " lsp
  lua require'lspconfig'.gopls.setup{}
  lua require'lspconfig'.clangd.setup{}
  lua require'lspconfig'.pyright.setup{}

  nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> gD :lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
  nnoremap <silent> K  :lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> [d :lua vim.lsp.diagnostic.goto_prev()<CR>
  nnoremap <silent> ]d :lua vim.lsp.diagnostic.goto_next()<CR>
  nnoremap <silent> <leader>ca :lua print(vim.inspect(vim.lsp.buf.code_action()))<CR>
  nnoremap <silent> <leader>lf :lua vim.lsp.buf.formatting()<CR>

  nnoremap <silent> <C-LeftMouse> <LeftMouse>:lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> <RightMouse> <LeftMouse>:lua vim.inspect(vim.lsp.buf.code_action())<CR>

  " treesitter
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = 'maintained',
    highlight = {
      enable = true,
    },
  }
EOF

  " snippets
  imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
else
  if enable_coc
    " https://github.com/neoclide/coc.nvim#example-vim-configuration
    let g:coc_disable_startup_warning = 1
    set nobackup
    set nowritebackup
    set shortmess+=c

    if has('nvim-0.5.0') || has('patch-8.1.1564')
      set signcolumn=number
    else
      set signcolumn=yes
    endif

    nmap <silent> [d <Plug>(coc-diagnostic-prev)
    nmap <silent> ]d <Plug>(coc-diagnostic-next)

    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . ' ' . expand('<cword>')
      endif
    endfunction

    autocmd CursorHold * silent call CocActionAsync('highlight')

    nmap <leader>rn <Plug>(coc-rename)
    nmap <leader>ca <Plug>(coc-codeaction)
    nmap <leader>qf <Plug>(coc-fix-current)
    xmap <leader>lf <Plug>(coc-format-selected)
    nmap <leader>lf <Plug>(coc-format-selected)
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)
    " nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>
    nnoremap <silent><nowait> <leader>s  :<C-u>CocList outline<cr>

    augroup coc_sth_group
      autocmd!
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    command! -nargs=0 Format :call CocAction('format')
    command! -nargs=? Fold   :call CocAction('fold', <f-args>)
    command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    " set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " coc and fzf integration
    let g:coc_fzf_preview = ''
    let g:coc_fzf_opts = []
    nnoremap <silent> <leader>d :CocFzfList diagnostics<CR>
  endif
  " vim-polyglot syntax highlighting
  " golang
  let g:go_highlight_chan_whitespace_error = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_space_tab_error = 1
  let g:go_highlight_trailing_whitespace_error = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_parameters = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_generate_tags = 1
  let g:go_highlight_string_spellcheck = 1
  let g:go_highlight_format_strings = 1
  let g:go_highlight_variable_declarations = 0
  let g:go_highlight_variable_assignments = 0
  let g:go_highlight_diagnostic_errors = 1
  let g:go_highlight_diagnostic_warnings = 1
endif

