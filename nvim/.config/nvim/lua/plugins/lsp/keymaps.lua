local M = {}

M.set_global_keymaps = function()
  local fzf = require('fzf-lua')
  vim.keymap.set('n', 'gD', fzf.lsp_declarations)
  vim.keymap.set('n', 'gd', fzf.lsp_definitions)
  vim.keymap.set('n', 'gr', fzf.lsp_references)
  vim.keymap.set('n', 'gi', fzf.lsp_implementations)
  vim.keymap.set('n', '<leader>d', fzf.lsp_workspace_diagnostics)
  vim.keymap.set('n', '<leader>s', fzf.lsp_live_workspace_symbols)
  vim.keymap.set('n', '<leader>ca', fzf.lsp_code_actions)
end

M.set_buf_keymaps = function(client, bufnr)
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

  local bufopts = { remap = false, silent = false, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
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
