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

---@type PluginModule
return {
  plugins = {
    'https://github.com/neovim/nvim-lspconfig',
    { src = 'https://github.com/mason-org/mason.nvim', enabled = not is_nixos },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim', enabled = not is_nixos },
    'https://github.com/j-hui/fidget.nvim',
  },
  config = function()
    require('plugins.lsp.keymaps').set_global_keymaps()

    vim.lsp.inlay_hint.enable()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require('plugins.lsp.keymaps').set_buf_keymaps(client, args.buf)
        require('plugins.lsp.highlights').set_lsp_highlights(client, args.buf)
      end,
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = servers,
      automatic_enable = true,
    })
    require('fidget').setup({})
  end,
}
