return {
  {
    'SmiteshP/nvim-navic',
    opts = {
      lsp = {
        auto_attach = true,
      },
      highlight = true,
      safe_output = true,
    },
    config = function(_, opts)
      require('nvim-navic').setup(opts)
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  },
}
