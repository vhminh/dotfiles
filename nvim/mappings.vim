nnoremap <C-c> :nohlsearch<CR><CR>

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

" Navigate with rendered line instead of logical line
nnoremap k gk
nnoremap j gj
