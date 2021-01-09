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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" Install plugins
if need_to_install_plugins == 1
	echo "Installing plugins..."
	silent! PlugInstall
	echo "Done!"
	q
endif

source $HOME/.config/nvim/plugins/coc.vim
source $HOME/.config/nvim/plugins/onedark.vim
source $HOME/.config/nvim/plugins/lightline.vim
source $HOME/.config/nvim/plugins/nerdtree.vim
source $HOME/.config/nvim/plugins/nerdtree-git.vim
source $HOME/.config/nvim/plugins/gitgutter.vim
source $HOME/.config/nvim/plugins/tagbar.vim
source $HOME/.config/nvim/plugins/fzf.vim

