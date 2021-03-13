nnoremap <C-c> :nohlsearch<CR>
nnoremap <ESC> :nohlsearch<CR>

" Map Ctrl-C to ESC
" since I remap Capslock to Ctrl
" and C-c is easier to reach than C-[
map <C-c> <ESC>
map! <C-c> <ESC>

" Fix Y behavior to yank to the end of the line
nmap Y y$

" Keep the visual after indenting block in visual mode
vmap < <gv
vmap > >gv

" Set leader key
let mapleader=" "

" Move between panes
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
tnoremap <M-h> <C-w>h
tnoremap <M-j> <C-w>j
tnoremap <M-k> <C-w>k
tnoremap <M-l> <C-w>l

" Resize panes
nnoremap <C-w><C-h> :vertical resize -2<CR>
nnoremap <C-w><C-j> :resize -2<CR>
nnoremap <C-w><C-k> :resize +2<CR>
nnoremap <C-w><C-l> :vertical resize +2<CR>

" Navigate with rendered line instead of logical line
nnoremap k gk
nnoremap j gj
