local colors = require('colors').raw

vim.g['onedark_color_overrides'] = {
  background = colors.background,
  comment_grey = colors.light_grey,
  cursor_grey = colors.slightly_light_grey,
  visual_grey = colors.grey,
  menu_grey = colors.grey,
  vertsplit = colors.light_grey,
}

local function onedark_set_color(hl_group, color)
  vim.fn['onedark#extend_highlight'](hl_group, { fg = color })
end

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    onedark_set_color('Identifier', colors.white)
    onedark_set_color('Function', colors.blue)
    onedark_set_color('Keyword', colors.purple)
    onedark_set_color('PreProc', colors.purple)
    onedark_set_color('Include', colors.purple)
    onedark_set_color('PreCondit', colors.purple)
    onedark_set_color('Type', colors.white)
    onedark_set_color('StorageClass', colors.purple)
    onedark_set_color('Structure', colors.purple)
    onedark_set_color('Typedef', colors.cyan)

    -- vim.api.nvim_set_hl(0, '@lsp.type.class', { fg = colors.yellow.gui })
    vim.api.nvim_set_hl(0, '@lsp.type.class', { link = 'Identifier' })
    vim.api.nvim_set_hl(0, '@lsp.type.enum', { link = 'Identifier' })
    -- vim.api.nvim_set_hl(0, '@lsp.type.interface', { fg = colors.yellow.gui })
    vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = 'Identifier' })
    vim.api.nvim_set_hl(0, '@lsp.type.namespace', { link = 'Identifier' })
    vim.api.nvim_set_hl(0, '@lsp.type.struct', { link = 'Identifier' })
    -- vim.api.nvim_set_hl(0, '@lsp.type.type', { fg = colors.yellow.gui })
    vim.api.nvim_set_hl(0, '@lsp.type.type', { link = 'Identifier' })
    vim.api.nvim_set_hl(0, '@type.builtin', { link = 'Keyword' })

    vim.api.nvim_set_hl(0, 'vertsplit', { fg = 'Gray' })
  end,
})
