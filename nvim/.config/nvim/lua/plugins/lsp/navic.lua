---@type PluginModule
return {
  plugins = { 'https://github.com/SmiteshP/nvim-navic' },
  config = function()
    require('nvim-navic').setup({
      lsp = {
        auto_attach = true,
      },
      highlight = true,
      safe_output = true,
    })
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  end,
}
