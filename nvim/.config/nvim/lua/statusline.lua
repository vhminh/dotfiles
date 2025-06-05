local colors = require('colors')
local stl_bg = colors.bg3

local colors_by_mode = {
  n = colors.blue,
  i = colors.green,
  v = colors.yellow,
  [''] = colors.yellow,
  V = colors.yellow,
  c = colors.purple,
  no = colors.blue,
  s = colors.yellow,
  S = colors.yellow,
  [''] = colors.yellow,
  ic = colors.green,
  R = colors.red,
  Rv = colors.red,
  cv = colors.fg,
  ce = colors.fg,
  r = colors.fg,
  rm = colors.fg,
  ['r?'] = colors.fg,
  ['!'] = colors.purple,
  t = colors.purple,
}
local get_mode_color = function(mode)
  return colors_by_mode[mode]
end

local text_by_mode = {
  n = 'NORMAL',
  i = 'INSERT',
  v = 'VISUAL',
  [''] = 'V-BLOCK',
  V = 'V-LINE',
  c = 'COMMAND',
  no = 'OPERATOR',
  s = 'SELECT',
  S = 'S-LINE',
  [''] = 'S-BLOCK',
  ic = 'COMPLETION',
  R = 'REPLACE',
  Rv = 'VIRT-REPLACE',
  cv = 'EX',
  ce = 'EX-NORMAL',
  r = 'ENTER-PROMPT',
  rm = 'MORE_PROMPT',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  t = 'TERM',
}

local short_stl_filetypes = { 'NvimTree', 'Vista' }

local components = {}

components.mode = function()
  local mode = vim.fn.mode(1)
  return text_by_mode[mode]
end

components.buf_flags = function()
  local icons = {}
  if vim.bo.readonly then
    table.insert(icons, '')
  end
  if vim.bo.modifiable and vim.bo.modified then
    table.insert(icons, '')
  end
  return table.concat(icons, '')
end

components.fileencoding = function()
  return vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
end

components.fileformat = function()
  return vim.bo.fileformat
end

components.git = function()
  local dict = vim.b.gitsigns_status_dict or {}
  local str = {}
  if dict['head'] ~= nil then
    table.insert(str, string.format(' %s', dict['head']))
  end
  if dict['added'] and dict['added'] ~= 0 then
    table.insert(str, string.format('+%s', dict['added']))
  end
  if dict['changed'] and dict['changed'] ~= 0 then
    table.insert(str, string.format('~%s', dict['changed']))
  end
  if dict['removed'] and dict['removed'] ~= 0 then
    table.insert(str, string.format('-%s', dict['removed']))
  end
  return table.concat(str, ' ')
end

_G.statusline = {}

statusline.active = function()
  return string.format(
    ' %s %%t %s %%= %%= %%l / %%L %s %s %s ▊',
    components.mode(),
    components.buf_flags(),
    components.fileencoding(),
    components.fileformat(),
    components.git()
  )
end

statusline.inactive = function()
  return '%t %m %r'
end
statusline.short = function()
  return '%t %m %r'
end

local augroup = vim.api.nvim_create_augroup('statusline', { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'FileType' }, {
  group = augroup,
  pattern = '*',
  callback = function()
    if vim.tbl_contains(short_stl_filetypes, vim.bo.filetype) then
      vim.o.statusline = '%!v:lua.statusline.short()'
    else
      vim.wo.statusline = '%!v:lua.statusline.active()'
    end
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.wo.statusline = '%!v:lua.statusline.inactive()'
  end,
})
