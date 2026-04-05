---@type PluginModule
return {
  plugins = { 'https://github.com/windwp/nvim-autopairs' },
  config = function()
    require('nvim-autopairs').setup({})
  end,
}
