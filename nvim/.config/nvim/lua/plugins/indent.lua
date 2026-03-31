return {
  {
    src = 'https://github.com/lukas-reineke/indent-blankline.nvim',
    config = function()
      require('ibl').setup({
        indent = { char = '│' },
      })
    end,
  },
  { src = 'https://github.com/tpope/vim-sleuth' },
}
