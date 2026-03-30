local colors = require('colors')
local stl_bg = colors.bg3

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

local highlight_by_mode = {
  n = 'StatusLineModeNormal',
  i = 'StatusLineModeInsert',
  v = 'StatusLineModeVisual',
  [''] = 'StatusLineModeVisual',
  V = 'StatusLineModeVisual',
  c = 'StatusLineModeTerm',
  no = 'StatusLineModeNormal',
  s = 'StatusLineModeVisual',
  S = 'StatusLineModeVisual',
  [''] = 'StatusLineModeVisual',
  ic = 'StatusLineModeInsert',
  R = 'StatusLineModeReplace',
  Rv = 'StatusLineModeReplace',
  cv = 'StatusLineModeOther',
  ce = 'StatusLineModeOther',
  r = 'StatusLineModeOther',
  rm = 'StatusLineModeOther',
  ['r?'] = 'StatusLineModeOther',
  ['!'] = 'StatusLineModeTerm',
  t = 'StatusLineModeTerm',
}

local group = vim.api.nvim_create_augroup('statusline.highlight', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = group,
  callback = function()
    vim.api.nvim_set_hl(0, 'StatusLineBlue', { fg = colors.blue })
    vim.api.nvim_set_hl(0, 'StatusLineGreen', { fg = colors.green })
    vim.api.nvim_set_hl(0, 'StatusLineYellow', { fg = colors.yellow })
    vim.api.nvim_set_hl(0, 'StatusLineRed', { fg = colors.red })
    vim.api.nvim_set_hl(0, 'StatusLinePurple', { fg = colors.purple })
    vim.api.nvim_set_hl(0, 'StatusLineCyan', { fg = colors.cyan })

    vim.api.nvim_set_hl(0, 'StatusLineModeNormal', { fg = stl_bg, bg = colors.blue })
    vim.api.nvim_set_hl(0, 'StatusLineModeInsert', { fg = stl_bg, bg = colors.green })
    vim.api.nvim_set_hl(0, 'StatusLineModeVisual', { fg = stl_bg, bg = colors.yellow })
    vim.api.nvim_set_hl(0, 'StatusLineModeReplace', { fg = stl_bg, bg = colors.red })
    vim.api.nvim_set_hl(0, 'StatusLineModeTerm', { fg = stl_bg, bg = colors.purple })
    vim.api.nvim_set_hl(0, 'StatusLineModeOther', { fg = stl_bg, bg = colors.fg })
  end,
})

local short_stl_filetypes = { 'NvimTree', 'vista_kind' }

local components = {}

components.mode = function()
  local mode = vim.fn.mode(1)
  local text = text_by_mode[mode]
  local hi = highlight_by_mode[mode]
  return string.format('%%#%s# %s %%*', hi, text)
end

local devicons = require('nvim-web-devicons')
components.file_icon = function()
  local filename = vim.fn.expand('%:t')
  local ext = vim.fn.expand('%:e')
  local icon, hi = devicons.get_icon(filename, ext, { default = true })
  if icon == nil then
    return ''
  end
  return string.format('%%#%s#%s%%*', hi, icon)
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

vim.api.nvim_create_augroup('statusline.lsp_diagnostics', { clear = true })
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = 'statusline.lsp_diagnostics',
  callback = function(args)
    local bufnr = args.buf
    local diagnostics = vim.diagnostic.count(bufnr)
    vim.b[bufnr].stl_lsp_diagnostics = diagnostics
  end,
})

---@generic T
---@param value vim.NIL|T?
---@param default T
---@return T
local function nil_safe(value, default)
  if value == nil or value == vim.NIL then
    return default
  end
  return value
end

components.lsp_diagnostics = function()
  local diagnostics = nil_safe(vim.b.stl_lsp_diagnostics, {})

  local error = nil_safe(diagnostics[vim.diagnostic.severity.ERROR], 0)
  local warn = nil_safe(diagnostics[vim.diagnostic.severity.WARN], 0)
  local info = nil_safe(diagnostics[vim.diagnostic.severity.INFO], 0)
  local hint = nil_safe(diagnostics[vim.diagnostic.severity.HINT], 0)
  local strs = {}
  if error > 0 then
    table.insert(strs, string.format('%%#StatusLineRed# %d%%*', error))
  end
  if warn > 0 then
    table.insert(strs, string.format('%%#StatusLineYellow# %d%%*', warn))
  end
  if info > 0 then
    table.insert(strs, string.format('%%#StatusLineBlue# %d%%*', info))
  end
  if hint > 0 then
    table.insert(strs, string.format('%%#StatusLineCyan# %d%%*', hint))
  end
  return table.concat(strs, ' ')
end

---@param lsp_clients { id: integer, name: string }[]
local function make_string(lsp_clients)
  local names = {}
  for _, client in ipairs(lsp_clients) do
    table.insert(names, client.name)
  end
  return table.concat(names, ',')
end

-- we have to keep track of attached clients ourselves
-- because vim.lsp.get_clients() doesn't give the latest list on LspDetach
-- https://github.com/neovim/neovim/pull/20148
vim.api.nvim_create_augroup('statusline.lsp_clients', { clear = true })
vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  group = 'statusline.lsp_clients',
  callback = function(args)
    local bufnr = args.buf
    local active_clients = vim.b[bufnr].lsp_clients or {}
    local client_id = args.data.client_id
    if args.event == 'LspAttach' then
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        table.insert(active_clients, { id = client.id, name = client.name })
      end
    elseif args.event == 'LspDetach' then
      for i, c in ipairs(active_clients) do
        if c.id == client_id then
          table.remove(active_clients, i)
          break
        end
      end
    end
    vim.b[bufnr].stl_lsp_clients = active_clients
    vim.b[bufnr].stl_lsp_clients_str = make_string(active_clients)
  end,
})

components.lsp_clients = function()
  local str = vim.b.stl_lsp_clients_str
  if str == vim.NIL or str == nil or str == '' then
    return ''
  end
  return string.format(' %%#StatusLineCyan#%s%%*', str)
end

components.git = function()
  local dict = vim.b.gitsigns_status_dict or {}
  local t = {}
  if dict['head'] ~= nil then
    table.insert(t, string.format('%%#StatusLinePurple# %s%%*', dict['head']))
  end
  if dict['added'] and dict['added'] ~= 0 then
    table.insert(t, string.format('%%#StatusLineGreen#+%d%%*', dict['added']))
  end
  if dict['changed'] and dict['changed'] ~= 0 then
    table.insert(t, string.format('%%#StatusLineYellow#~%d%%*', dict['changed']))
  end
  if dict['removed'] and dict['removed'] ~= 0 then
    table.insert(t, string.format('%%#StatusLineRed#-%d%%*', dict['removed']))
  end
  if next(t) == nil then
    return ''
  end
  return string.format(' %s', table.concat(t, ' '))
end

_G.statusline = {}

statusline.active = function()
  return string.format(
    '%s %s %%#StatusLinePurple#%%t %s%%*  %s %%= %%= %%l / %%L %%#StatusLineGreen#%s %s%%*%s%s %%#StatusLineBlue#▊%%*',
    components.mode(),
    components.file_icon(),
    components.buf_flags(),
    components.lsp_diagnostics(),
    components.fileencoding(),
    components.fileformat(),
    -- optional components, they already have padding spaces
    components.lsp_clients(),
    components.git()
  )
end

statusline.inactive = function()
  return ' %t %m %r'
end
statusline.short = function()
  return ' %t %m %r'
end

local augroup = vim.api.nvim_create_augroup('statusline', { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'FileType' }, {
  group = augroup,
  pattern = '*',
  callback = function()
    if vim.tbl_contains(short_stl_filetypes, vim.bo.filetype) then
      vim.wo.statusline = '%!v:lua.statusline.short()'
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
