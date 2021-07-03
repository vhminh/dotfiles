let need_to_install_plugins = 0
if has('nvim')
	let vimplug_path = '~/.local/share/nvim/site/autoload/plug.vim'
else
	let vimplug_path = '~/.vim/autoload/plug.vim'
endif

if empty(glob(vimplug_path))
	silent execute '!curl -fLo ' . vimplug_path . ' --create-dirs '
		\ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	"autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	let need_to_install_plugins = 1
endif

if has('nvim-0.5')
	source $HOME/.config/nvim/vimplug/nvim.vim
else
	source $HOME/.config/nvim/vimplug/vim.vim
endif

" Install plugins
if need_to_install_plugins == 1
	echo "Installing plugins..."
	silent! PlugInstall
	echo "Done!"
	q
endif

source $HOME/.config/nvim/vimplug/settings.vim

