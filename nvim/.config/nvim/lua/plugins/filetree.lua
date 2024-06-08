require 'nvim-tree'.setup {
  diagnostics = {
    enable = true,
  },
  renderer = {
    group_empty = true,
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
}
vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeFindFile<CR>')
