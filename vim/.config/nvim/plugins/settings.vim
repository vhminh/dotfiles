if has('nvim-0.5')
	source $HOME/.config/nvim/plugins/settings/lsp.vim
	source $HOME/.config/nvim/plugins/settings/completion.vim
	source $HOME/.config/nvim/plugins/settings/nvim-tree.vim
	source $HOME/.config/nvim/plugins/settings/galaxyline.vim
else
	source $HOME/.config/nvim/plugins/settings/lightline.vim
	source $HOME/.config/nvim/plugins/settings/tagbar.vim
	source $HOME/.config/nvim/plugins/settings/coc.vim
	source $HOME/.config/nvim/plugins/settings/vim-go.vim
	source $HOME/.config/nvim/plugins/settings/nerdtree.vim
	source $HOME/.config/nvim/plugins/settings/nerdtree-git.vim
endif

source $HOME/.config/nvim/plugins/settings/onedark.vim
source $HOME/.config/nvim/plugins/settings/gitgutter.vim
source $HOME/.config/nvim/plugins/settings/fzf.vim

