return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sync_root_with_cwd = true,
      diagnostics = {
        enable = true,
      },
      renderer = {
        group_empty = true,
      },
      actions = {
        change_dir = {
          enable = false,
        },
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
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)
      local view = require('nvim-tree.view')
      local api = require('nvim-tree.api')
      vim.keymap.set('n', '<leader>e', function()
        api.tree.find_file({ open = true, focus = true })
      end)

      -- replacing built-in `gf` to focus the directory in nvim-tree
      --
      -- nvim-tree hijacks directory editing and opens the tree view using the directory as root
      -- this one focuses the directory in nvim-tree but keeps the tree root at cwd
      ---@return boolean
      local function focus_dir_under_cursor()
        local path_under_cursor = vim.fn.expand('<cfile>')
        if path_under_cursor == '' then
          return false
        end
        local buf_dir = vim.fn.expand('%:p:h')
        local path = vim.fn.simplify(buf_dir .. '/' .. path_under_cursor)
        if vim.fn.isdirectory(path) ~= 1 then
          return false
        end
        api.tree.find_file({ buf = path, open = true, focus = true })
        api.tree.expand_all()
        return true
      end
      vim.keymap.set('n', 'gf', function()
        if focus_dir_under_cursor() then
          return
        end
        vim.cmd('normal! gf')
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
    end,
  },
}
