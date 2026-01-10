local is_nixos = vim.fn.filereadable('/etc/NIXOS') ~= 0

-- define lsp signs
vim.fn.sign_define('LspDiagnosticsSignError', {
  text = '',
  texthl = 'LspDiagnosticsSignError',
})
vim.fn.sign_define('LspDiagnosticsSignWarning', {
  text = '',
  texthl = 'LspDiagnosticsSignWarning',
})

vim.fn.sign_define('LspDiagnosticsSignInformation', {
  text = '',
  texthl = 'LspDiagnosticsSignInformation',
})

vim.fn.sign_define('LspDiagnosticsSignHint', {
  text = '',
  texthl = 'LspDiagnosticsSignHint',
})

local on_attach = function(client, bufnr)
  require('plugins.lsp.keymaps').set_buf_keymaps(client, bufnr)
  require('plugins.lsp.highlights').set_lsp_highlights(client, bufnr)
end

local servers =
  { 'lua_ls', 'rust_analyzer', 'gopls', 'clangd', 'pyright', 'nil_ls', 'jdtls', 'protols', 'zls', 'ts_ls' }
if not is_nixos then
  for k, v in ipairs(servers) do
    if v == 'nil_ls' then
      table.remove(servers, k)
      break
    end
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', enabled = not is_nixos, opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        enabled = not is_nixos,
        opts = {
          ensure_installed = servers,
          automatic_enable = true,
        },
      },
    },
    init = function()
      require('plugins.lsp.keymaps').set_global_keymaps()
      vim.lsp.inlay_hint.enable()
    end,
    config = function()
      vim.lsp.config('*', {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
      })
    end,
  },
  { 'j-hui/fidget.nvim', opts = {} },
}
