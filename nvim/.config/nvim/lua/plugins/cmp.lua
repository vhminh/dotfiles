return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
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
