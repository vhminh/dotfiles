# dotfiles
My dotfiles for `X` window server, `bash`, `neovim`, `alacritty`, `tmux`

## Configs
- Xorg
	- Map `Capslock` to `Control` (or `ESC`)
	- Increase keyboard key repeat rate
- Neovim
	- onedark theme
	- fzf
	- For vim and neovim < 0.5
		- nerdtree
		- tagbar
		- devicons
		- coc completion
		- lightline
	- For neovim >= 0.5
		- nvim-tree
		- vista
		- builtin lsp
		- galaxy line
		- tree-sitter
- Bash aliases
	- Use `exa` instead of `ls`
- Alacritty

## Dependencies
### For (neo)vim
- ctags (for tagbar)
- Fira Mono nerd font (for devicons)
- ripgrep (for fzf)
- Language servers (gopls, clangd, ...) for neovim lsp
### For bash alias
- exa
### For Alacritty
- Fira Mono nerd font
