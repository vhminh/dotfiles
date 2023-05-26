local colors = require('colors').raw

vim.g['onedark_color_overrides'] = colors

vim.cmd([[
if (has('autocmd') && !has('gui_running'))
augroup colorextend
autocmd!
let colors = onedark#GetColors()
autocmd ColorScheme * call onedark#extend_highlight('Keyword', { 'fg': colors.purple })
augroup END
endif
]])

vim.cmd([[
augroup highlight_vertsplit
autocmd!
autocmd Colorscheme * highlight vertsplit guifg=Gray guibg=bg
augroup END
]])
