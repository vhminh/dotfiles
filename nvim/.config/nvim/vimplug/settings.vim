if has('nvim-0.5')
	lua require('lsp')
	source $HOME/.config/nvim/viml/completion.vim
	source $HOME/.config/nvim/viml/vista.vim
	source $HOME/.config/nvim/viml/tree-sitter.vim
	source $HOME/.config/nvim/viml/nvim-tree.vim
	lua require('nvim-icons')
	source $HOME/.config/nvim/viml/trouble.vim
	lua require('galaxy')
else
	source $HOME/.config/nvim/viml/lightline.vim
	source $HOME/.config/nvim/viml/tagbar.vim
	source $HOME/.config/nvim/viml/coc.vim
	source $HOME/.config/nvim/viml/vim-go.vim
	source $HOME/.config/nvim/viml/nerdtree.vim
	source $HOME/.config/nvim/viml/nerdtree-git.vim
endif

source $HOME/.config/nvim/viml/onedark.vim
source $HOME/.config/nvim/viml/gitgutter.vim
source $HOME/.config/nvim/viml/fzf.vim
