local colors = require('colors').gui

vim.g['sneak#label'] = true
vim.g['sneak#prompt'] = '> '
vim.keymap.set('n', 'f', '<Plug>Sneak_f')
vim.keymap.set('n', 'F', '<Plug>Sneak_F')
vim.keymap.set('n', 't', '<Plug>Sneak_t')
vim.keymap.set('n', 'T', '<Plug>Sneak_T')

vim.cmd([[
augroup sneak_highlight
autocmd!
autocmd ColorScheme * highlight Sneak guifg=]] .. colors.background .. ' guibg=' .. colors.yellow .. [[

autocmd ColorScheme * highlight SneakLabel guifg=]] .. colors.background .. ' guibg=' .. colors.yellow .. [[

augroup END
]])
