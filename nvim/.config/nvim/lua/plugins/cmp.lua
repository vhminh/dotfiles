---@type PluginModule
return {
  plugins = {
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-path',
    'https://github.com/hrsh7th/cmp-buffer',
    'https://github.com/hrsh7th/cmp-vsnip',
    'https://github.com/hrsh7th/vim-vsnip',
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/onsails/lspkind-nvim',
    'https://github.com/folke/lazydev.nvim',
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
}
