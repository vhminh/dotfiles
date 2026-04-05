local on_attach = function(bufnr)
  local gs = package.loaded.gitsigns

  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('n', ']c', function()
    if vim.wo.diff then
      return ']c'
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return '<Ignore>'
  end, { expr = true })

  map('n', '[c', function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true })

  map('n', '<leader>hp', gs.preview_hunk)
  map('n', '<leader>hr', gs.reset_hunk)
  map('n', '<leader>hs', gs.stage_hunk)
  map('n', '<leader>hu', gs.undo_stage_hunk)
end

---@type PluginModule
return {
  plugins = { 'https://github.com/lewis6991/gitsigns.nvim' },
  init = function()
    local group = vim.api.nvim_create_augroup('gitsigns_highlight', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      group = group,
      callback = function()
        vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitGutterAdd' })
        vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitGutterChange' })
        vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitGutterChange' })
        vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitGutterDelete' })
        vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'GitGutterDelete' })
      end,
    })
  end,
  config = function()
    require('gitsigns').setup({
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged_enable = false,
      current_line_blame = true,
      on_attach = on_attach,
    })
  end,
}
