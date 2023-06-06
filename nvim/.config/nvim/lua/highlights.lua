local colors = {}
for k, v in pairs(require('colors').gui) do
  colors[k] = { fg = v }
end

local hl_treesitter_groups = function()
  vim.api.nvim_set_hl(0, '@type.qualifier', colors.purple)
end

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = hl_treesitter_groups,
})
