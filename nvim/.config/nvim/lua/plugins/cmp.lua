---@type PluginSpec[]
return {
  {
    src = 'https://github.com/folke/lazydev.nvim',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('lazydev_init', { clear = true }),
        pattern = 'lua',
        callback = function()
          require('lazydev').setup({
            library = {
              { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
          })
        end,
      })
    end,
  },
  {
    src = 'https://github.com/hrsh7th/nvim-cmp',
    deps = {
      { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
      { src = 'https://github.com/hrsh7th/cmp-path' },
      { src = 'https://github.com/hrsh7th/cmp-buffer' },
      { src = 'https://github.com/hrsh7th/cmp-vsnip' },
      { src = 'https://github.com/hrsh7th/vim-vsnip' },
      { src = 'https://github.com/rafamadriz/friendly-snippets' },
      { src = 'https://github.com/onsails/lspkind-nvim' },
    },
    init = function()
      vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
      vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
      vim.g.completion_trigger_on_delete = true
    end,
    config = function()
      local lspkind = require('lspkind')
      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'vsnip' },
          { name = 'buffer' },
          { name = 'lazydev', group_index = 0 },
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
        }),
        snippet = {
          expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text',
          }),
        },
      })
    end,
  },
}
