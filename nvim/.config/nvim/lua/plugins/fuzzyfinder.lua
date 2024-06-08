local telescope = require('telescope')

telescope.setup({
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
    dynamic_preview_title = true,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
})
require('telescope').load_extension('fzf')

vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  command = 'setlocal number',
})

local telescope_builtin = require('telescope.builtin')
local pickers = require('better-telescope-builtins')

vim.keymap.set('n', '<leader>a', telescope_builtin.builtin)
vim.keymap.set('n', '<C-f>', pickers.find_files)
vim.keymap.set('n', '<leader>f', pickers.find_files)
vim.keymap.set('n', '<leader>b', pickers.buffers)
vim.keymap.set('n', '<leader>g', function()
  telescope_builtin.live_grep({
    path_display = { 'tail' },
  })
end)

vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_dynamic_workspace_symbols)
