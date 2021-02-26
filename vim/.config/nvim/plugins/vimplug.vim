let need_to_install_plugins = 0
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	"autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	let need_to_install_plugins = 1
endif

call plug#begin('~/.vim/plugged')
Plug 'jiangmiao/auto-pairs'
Plug 'joshdick/onedark.vim'
Plug 'preservim/tagbar'
Plug 'preservim/nerdtree' |
			\ Plug 'Xuyuanp/nerdtree-git-plugin' |
			\ Plug 'ryanoasis/vim-devicons' |
			\ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
if has('nvim-0.5')
	" Use built-in nvim lsp
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
else
	" Use Coc for older versions
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
endif
Plug 'tpope/vim-commentary'
call plug#end()

" Install plugins
if need_to_install_plugins == 1
	echo "Installing plugins..."
	silent! PlugInstall
	echo "Done!"
	q
endif

if has('nvim-0.5')
	" Source lsp settings
	source $HOME/.config/nvim/plugins/lsp.vim
	source $HOME/.config/nvim/plugins/completion.vim
else
	" Source Coc settings
	source $HOME/.config/nvim/plugins/coc.vim
	source $HOME/.config/nvim/plugins/vim-go.vim
endif
source $HOME/.config/nvim/plugins/onedark.vim
source $HOME/.config/nvim/plugins/lightline.vim
source $HOME/.config/nvim/plugins/nerdtree.vim
source $HOME/.config/nvim/plugins/nerdtree-git.vim
source $HOME/.config/nvim/plugins/gitgutter.vim
source $HOME/.config/nvim/plugins/tagbar.vim
source $HOME/.config/nvim/plugins/fzf.vim

