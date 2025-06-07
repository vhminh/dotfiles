return {
  {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local metals_config = require('metals').bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        enableSemanticHighlighting = true,
        excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
      }
      metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()
      metals_config.on_attach = function(client, bufnr)
        require('plugins.lsp.keymaps').set_buf_keymaps(client, bufnr)
        require('plugins.lsp.highlights').set_lsp_highlights(client, bufnr)
      end
      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'scala', 'sbt', 'java' },
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
