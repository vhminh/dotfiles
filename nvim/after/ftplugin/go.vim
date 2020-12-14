" Jump to definition and jump back
nnoremap <buffer> gd :GoDef<CR>
nnoremap <buffer> <C-]> :GoDef<CR>
nnoremap <buffer> <C-LeftMouse> <LeftMouse>:GoDef<CR>
nnoremap <buffer> g<LeftMouse> <LeftMouse>:GoDef<CR>
nnoremap <buffer> gb :GoDefPop<CR>

" Shortcut to run
nnoremap <buffer> <F5> :GoRun<CR>
nnoremap <buffer> <S-F5> :GoDebug<CR>

