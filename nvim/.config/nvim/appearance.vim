syntax on

" Render whitespace characters
"set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣
set listchars=tab:>·,trail:~
set list

" Split border
set fillchars+=vert:\|
hi vertsplit guifg=Gray guibg=bg

" GUI font
if has("gui_running")
	set guifont=Fira\ Mono\ Nerd\ Font\ Medium\ 12
endif

