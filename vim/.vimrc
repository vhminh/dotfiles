set nocompatible
let mapleader=" "

let enable_coc = 0

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
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
if executable('ctags')
  Plug 'preservim/tagbar'
end
if enable_coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
set notermguicolors
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

" Dont auto change dir when open another buffer
" since we need netrw to open the working directory
set noautochdir

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
" STATUS LINE                                "
""""""""""""""""""""""""""""""""""""""""""""""
let colors = onedark#GetColors()
let background_color = has_key(colors, 'background') ? colors.background : colors.black
execute 'highlight' 'StatusLineHighlightRed'  'guibg=' colors.red.gui 'ctermbg=' colors.red.cterm  'guifg=' background_color.gui 'ctermfg=' background_color.cterm
execute 'highlight' 'StatusLineHighlightGreen' 'guibg=' colors.green.gui 'ctermbg=' colors.green.cterm 'guifg=' background_color.gui 'ctermfg=' background_color.cterm
execute 'highlight' 'StatusLineHighlightBlue' 'guibg=' colors.blue.gui 'ctermbg=' colors.blue.cterm 'guifg=' background_color.gui 'ctermfg=' background_color.cterm
execute 'highlight' 'StatusLineHighlightYellow' 'guibg=' colors.yellow.gui 'ctermbg=' colors.yellow.cterm 'guifg=' background_color.gui 'ctermfg=' background_color.cterm
execute 'highlight' 'StatusLineHighlightPurple' 'guibg=' colors.purple.gui 'ctermbg=' colors.purple.cterm 'guifg=' background_color.gui 'ctermfg=' background_color.cterm
execute 'highlight' 'StatusLineHighlightGray' 'guibg=' colors.special_grey.gui 'ctermbg=' colors.special_grey.cterm 'guifg=' background_color.gui 'ctermfg=' background_color.cterm

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

augroup SLActive
  autocmd!
  autocmd WinEnter * setlocal statusline=%!StatusLine(1)
  autocmd VimEnter * setlocal statusline=%!StatusLine(1)
  autocmd BufWinEnter * setlocal statusline=%!StatusLine(1)
  autocmd WinLeave * setlocal statusline=%!StatusLine(0)
augroup END

augroup SLGitBranch
  autocmd!
  autocmd WinEnter * let w:git_branch = GetGitBranch()
  autocmd VimEnter * let w:git_branch = GetGitBranch()
  autocmd BufWinEnter * let w:git_branch = GetGitBranch()
augroup END

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
  let result = StatusLineMode(a:is_active) . ' %t %y %m%< %r %h %w%=Current: %-5l Total: %-5L ' . StatusLineGitBranch() . ' '
  let [a,m,r] = GitGutterGetHunkSummary()
  if a + m + r > 0
    let result = result . printf('+%d ~%d -%d', a, m, r) . ' '
  end
  return result
endfunction

if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
  set noshowmode
endif
set noruler

set laststatus=2
set noshowcmd
set cmdheight=1


""""""""""""""""""""""""""""""""""""""""""""""
" GIT GUTTER                                 "
""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufWritePost * GitGutter
let g:gitgutter_map_keys = 0
nmap <leader>gn <Plug>(GitGutterNextHunk)
nmap <leader>gp <Plug>(GitGutterPrevHunk)
nmap <leader>ghp <Plug>(GitGutterPreviewHunk)
nmap <leader>ghs <Plug>(GitGutterStageHunk)
nmap <leader>ghu <Plug>(GitGutterUndoHunk)


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






if !enable_coc
  finish
end
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

"" Give more space for displaying messages.
"set cmdheight=2

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

augroup mygroup
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
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

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

" " Mappings for CoCList
" " Show all diagnostics.
" nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>

