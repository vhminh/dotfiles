filetype plugin indent on

" Setup folding
set foldmethod=indent
set foldlevelstart=99

" Split pane direction
set splitbelow
set splitright

" Other
set hidden
set encoding=utf8
set nowrap                      " Dont wrap long lines
set showcmd                     " Show when pressing leader key
set clipboard=unnamedplus       " Copy from and paste to clipboard
set showmatch                   " Dont know what this is
set backspace=indent,eol,start  " Backspace
set smartindent
set autoread                    " Auto reload file from disk after running command
set autowriteall                " Auto save file
set ignorecase                  " Ignore case when search
set smartcase                   " Smart case when search
set hlsearch                    " Highlight search results
set incsearch                   " Jump to search result as we type
set mouse=a                     " Enable mouse
set noexpandtab                 " Don't expand tab to spaces
set shiftwidth=4                " Shiftwidth indent with >>
set tabstop=4                   " Tab size when render
set scrolloff=5                 " Scroll offset
set number                      " Enable number
set relativenumber              " Enable relative number
set cursorline                  " Highlight the current line the cursor is on
set noshowmode                  " Dont display sth like --INSERT-- because we can set it in status line

