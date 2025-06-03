local M = {}

M.set_lsp_keymaps = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { remap = false, silent = false, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  if client.name == 'lua_ls' and vim.fn.executable('stylua') then
    vim.keymap.set('n', '<leader>lf', require('stylua-nvim').format_file)
  else
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, bufopts)
  end
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, bufopts)
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, bufopts)
  vim.keymap.set('n', '[e', function()
    vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
  end, bufopts)
  vim.keymap.set('n', ']e', function()
    vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
  end, bufopts)
end

return M
