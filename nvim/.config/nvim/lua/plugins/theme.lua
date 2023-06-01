local colors = require('colors')

vim.g['onedark_color_overrides'] = {
  background = colors.raw.background,
  comment_grey = colors.raw.light_grey,
  cursor_grey = colors.raw.slightly_light_grey,
  visual_grey = colors.raw.grey,
  menu_grey = colors.raw.grey,
  vertsplit = colors.raw.light_grey,
}

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
