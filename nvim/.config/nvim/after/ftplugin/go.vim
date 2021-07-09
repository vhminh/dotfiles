if !has('nvim-0.5')
	" Jump to definition with mouse
	nnoremap <buffer> <C-LeftMouse> <LeftMouse>:GoDef<CR>
	nnoremap <buffer> g<LeftMouse> <LeftMouse>:GoDef<CR>
	
	" Shortcut to run
	nnoremap <buffer> <F5> :GoRun<CR>
	nnoremap <buffer> <S-F5> :GoDebug<CR>
endif

