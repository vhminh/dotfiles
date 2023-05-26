require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '-g',
      '!{.git,node_modules}',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}
require('telescope').load_extension('fzf')
local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>a', telescope_builtin.builtin)
-- files and finders
vim.keymap.set('n', '<C-f>', function()
  telescope_builtin.find_files({
    shorten_path = true,
    path_display = { 'smart' },
    find_command = { 'fd', '--type', 'file', '--hidden', '--exclude', '.git' },
  })
end)
vim.keymap.set('n', '<leader>f', function()
  telescope_builtin.find_files({
    shorten_path = true,
    path_display = { 'smart' },
    find_command = { 'fd', '--type', 'file', '--hidden', '--exclude', '.git' },
  })
end)
vim.keymap.set('n', '<leader>b', telescope_builtin.buffers)
vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep)
-- lsp
vim.keymap.set('n', 'gr', telescope_builtin.lsp_references)
vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>d', telescope_builtin.diagnostics)
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations)
