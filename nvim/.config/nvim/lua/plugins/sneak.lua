local colors = require('colors').gui

vim.g['sneak#label'] = true
vim.g['sneak#prompt'] = '> '
vim.keymap.set('n', 'f', '<Plug>Sneak_f')
vim.keymap.set('n', 'F', '<Plug>Sneak_F')
vim.keymap.set('n', 't', '<Plug>Sneak_t')
vim.keymap.set('n', 'T', '<Plug>Sneak_T')

local sneak_hl_augroup = vim.api.nvim_create_augroup('sneak_highlight', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = sneak_hl_augroup,
  callback = function()
    vim.api.nvim_set_hl(0, 'Sneak', { fg = colors.background, bg = colors.yellow })
    vim.api.nvim_set_hl(0, 'SneakLabel', { fg = colors.background, bg = colors.yellow })
  end,
})
