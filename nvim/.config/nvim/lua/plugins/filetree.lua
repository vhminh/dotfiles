require 'nvim-tree'.setup {
	diagnostics = {
		enable = true,
	},
	renderer = {
		group_empty = true,
	},
}
vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeFindFile<CR>')
