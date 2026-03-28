return {
  {
    'https://codeberg.org/andyg/leap.nvim',
    config = function()
      vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        group = vim.api.nvim_create_augroup('leap_hightlights', { clear = true }),
        callback = function()
          vim.api.nvim_set_hl(0, 'LeapMatch', { link = 'IncSearch' })
          vim.api.nvim_set_hl(0, 'LeapLabel', { link = 'Search' })
        end,
      })
    end,
  },
}
