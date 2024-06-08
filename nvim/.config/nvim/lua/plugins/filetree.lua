require('nvim-tree').setup({
  diagnostics = {
    enable = true,
  },
  renderer = {
    group_empty = true,
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  git = {
    ignore = false,
  },
  filters = {
    dotfiles = false,
    custom = { '.DS_Store' },
  },
})

local view = require('nvim-tree.view')
local api = require('nvim-tree.api')
vim.keymap.set('n', '<leader>e', function()
  api.tree.find_file({ open = true, focus = true })
end)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- save NvimTree window width on WinResized event
augroup('save_nvim_tree_state', { clear = true })
autocmd('WinResized', {
  group = 'save_nvim_tree_state',
  pattern = '*',
  callback = function()
    local filetree_winnr = view.get_winnr()
    if filetree_winnr ~= nil and vim.tbl_contains(vim.v.event['windows'], filetree_winnr) then
      vim.t['filetree_width'] = vim.api.nvim_win_get_width(filetree_winnr)
    end
  end,
})

-- restore window size when openning NvimTree
api.events.subscribe(api.events.Event.TreeOpen, function()
  if vim.t['filetree_width'] ~= nil then
    view.resize(vim.t['filetree_width'])
  end
end)
