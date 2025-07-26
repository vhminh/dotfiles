local grep_rg_opts = '--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e'

return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      winopts = {
        preview = {
          layout = 'vertical',
        },
      },
      files = {
        previewer = false,
        formatter = 'path.filename_first',
        git_icons = true,
        rg_opts = [[--color=never --hidden --files -g '!.git']],
        fd_opts = [[--color=never --hidden --type f --type l --exclude .git]],
      },
      buffers = {
        formatter = 'path.filename_first',
      },
      grep = {
        grep_opts = '--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e',
        rg_opts = grep_rg_opts,
        path_shorten = 1,
      },
      lsp = {
        path_shorten = 1,
        includeDeclaration = false,
        symbols = {
          path_shorten = 1,
        },
      },
    },
    config = function(_, opts)
      local fzf = require('fzf-lua')
      fzf.setup(opts)
      fzf.register_ui_select()

      vim.keymap.set('n', '<C-f>', fzf.files)
      vim.keymap.set('n', '<leader>f', fzf.files)
      vim.keymap.set('n', '<leader>g', fzf.grep)
      vim.keymap.set('v', '<leader>g', function()
        local s = vim.fn.getpos('v')
        local e = vim.fn.getpos('.')
        local selected_lines = vim.fn.getregion(s, e, { type = vim.fn.mode() })
        if #selected_lines == 1 then
          fzf.grep({ search = selected_lines[1] })
        else
          local selected = table.concat(selected_lines, '\n')
          fzf.grep({
            search = selected,
            rg_opts = '--multiline ',
            multiline = 1,
          })
        end
      end)

      vim.keymap.set('n', '<leader>b', fzf.buffers)

      vim.keymap.set('n', '<leader>rs', fzf.resume)

      vim.keymap.set('n', '<leader>;', function()
        fzf.commands({
          actions = {
            ['enter'] = fzf.actions.ex_run_cr,
          },
        })
      end)

      vim.keymap.set('n', '<leader>a', fzf.builtin)
    end,
  },
}
