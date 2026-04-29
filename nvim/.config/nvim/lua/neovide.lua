vim.o.guifont = 'NotoSansM NF Cond Med:h18'
vim.g.neovide_remember_window_size = false
vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_scroll_animation_length = 0.12
vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_cursor_trail_size = 0.06

vim.api.nvim_set_current_dir(vim.env.PWD)

-- HACK: remove when neovide releases new version that supports `grid` option in config.toml
vim.defer_fn(function()
  vim.opt.columns = 128
  vim.opt.lines = 36
end, 20)
