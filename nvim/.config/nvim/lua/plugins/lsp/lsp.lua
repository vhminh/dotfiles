local is_nixos = vim.fn.filereadable('/etc/NIXOS') ~= 0

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
})

local on_attach = function(client, bufnr)
  require('plugins.lsp.keymaps').set_buf_keymaps(client, bufnr)
  require('plugins.lsp.highlights').set_lsp_highlights(client, bufnr)
end

local servers = {
  'lua_ls',
  'rust_analyzer',
  'gopls',
  'clangd',
  'pyright',
  'nil_ls',
  'jdtls',
  'protols',
  'zls',
  'ts_ls',
  'yamlls',
  'jsonls',
}
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
    src = 'https://github.com/neovim/nvim-lspconfig',
    deps = {
      {
        src = 'https://github.com/mason-org/mason.nvim',
        enabled = not is_nixos,
        config = function()
          require('mason').setup({})
        end,
      },
      {
        src = 'https://github.com/mason-org/mason-lspconfig.nvim',
        enabled = not is_nixos,
        config = function()
          require('mason-lspconfig').setup({
            ensure_installed = servers,
            automatic_enable = true,
          })
        end,
      },
    },
    config = function()
      require('plugins.lsp.keymaps').set_global_keymaps()
      vim.lsp.inlay_hint.enable()
      vim.lsp.config('*', { on_attach = on_attach })
    end,
  },
  {
    src = 'https://github.com/j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({})
    end,
  },
}
