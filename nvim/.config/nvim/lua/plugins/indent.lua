---@type PluginModule
return {
  plugins = {
    'https://github.com/lukas-reineke/indent-blankline.nvim',
    'https://github.com/tpope/vim-sleuth',
  },
  config = function()
    require('ibl').setup({
      indent = { char = '│' },
    })
  end,
}
