return {
  {
    'liuchengxu/vista.vim',
    init = function()
      vim.g.vista_default_executive = 'nvim_lsp'
      vim.keymap.set('n', '<leader>t', '<Cmd>Vista!!<CR>')
    end,
  },
}
