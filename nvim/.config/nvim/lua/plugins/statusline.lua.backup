return {
  {
    'NTBBloodbath/galaxyline.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local colors = require('colors')
      local stl_bg = colors.bg3

      local colors_by_mode = {
        n = colors.blue,
        i = colors.green,
        v = colors.yellow,
        [''] = colors.yellow,
        V = colors.yellow,
        c = colors.purple,
        no = colors.blue,
        s = colors.yellow,
        S = colors.yellow,
        [''] = colors.yellow,
        ic = colors.green,
        R = colors.red,
        Rv = colors.red,
        cv = colors.fg,
        ce = colors.fg,
        r = colors.fg,
        rm = colors.fg,
        ['r?'] = colors.fg,
        ['!'] = colors.purple,
        t = colors.purple,
      }
      local get_mode_color = function(mode)
        return colors_by_mode[mode]
      end

      local text_by_mode = {
        n = 'NORMAL',
        i = 'INSERT',
        v = 'VISUAL',
        [''] = 'V-BLOCK',
        V = 'V-LINE',
        c = 'COMMAND',
        no = 'OPERATOR',
        s = 'SELECT',
        S = 'S-LINE',
        [''] = 'S-BLOCK',
        ic = 'COMPLETION',
        R = 'REPLACE',
        Rv = 'VIRT-REPLACE',
        cv = 'EX',
        ce = 'EX-NORMAL',
        r = 'ENTER-PROMPT',
        rm = 'MORE_PROMPT',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        t = 'TERM',
      }
      local get_mode_text = function(mode)
        return text_by_mode[mode]
      end

      local gl = require('galaxyline')
      local condition = require('galaxyline.condition')
      local gls = gl.section
      gl.short_line_list = { 'NvimTree', 'vista' }

      gls.left[1] = {
        ViMode = {
          provider = function()
            local mode = vim.fn.mode()
            vim.api.nvim_command('hi GalaxyViMode guifg=' .. stl_bg .. ' guibg=' .. get_mode_color(mode))
            return '  ' .. get_mode_text(mode) .. ' '
          end,
          highlight = { colors.red, stl_bg },
        },
      }
      gls.left[2] = {
        Separator = {
          provider = function()
            return ' '
          end,
          highlight = { colors.fg, stl_bg },
        },
      }
      gls.left[3] = {
        FileIcon = {
          provider = 'FileIcon',
          condition = condition.buffer_not_empty,
          highlight = { require('galaxyline.providers.fileinfo').get_file_icon_color, stl_bg },
        },
      }
      gls.left[4] = {
        FileName = {
          provider = { 'FileName' },
          condition = condition.buffer_not_empty,
          separator = ' ',
          separator_highlight = { 'NONE', stl_bg },
          highlight = { colors.purple, stl_bg },
        },
      }
      gls.left[5] =
        { DiagnosticError = { provider = 'DiagnosticError', icon = '  ', highlight = { colors.red, stl_bg } } }
      gls.left[6] =
        { DiagnosticWarn = { provider = 'DiagnosticWarn', icon = '  ', highlight = { colors.yellow, stl_bg } } }
      gls.left[7] =
        { DiagnosticHint = { provider = 'DiagnosticHint', icon = '  ', highlight = { colors.cyan, stl_bg } } }
      gls.left[8] =
        { DiagnosticInfo = { provider = 'DiagnosticInfo', icon = '  ', highlight = { colors.blue, stl_bg } } }

      gls.right[1] = {
        TotalLines = {
          provider = function()
            local cur_line_num = vim.api.nvim_win_get_cursor(0)[1]
            local line_count = vim.api.nvim_buf_line_count(0)
            return cur_line_num .. ' / ' .. line_count
          end,
          separator_highlight = { 'NONE', stl_bg },
          highlight = { colors.fg, stl_bg },
        },
      }
      gls.right[2] = {
        FileEncode = {
          provider = 'FileEncode',
          separator = ' ',
          separator_highlight = { 'NONE', stl_bg },
          highlight = { colors.green, stl_bg },
        },
      }
      gls.right[3] = {
        FileFormat = {
          provider = 'FileFormat',
          separator = ' ',
          separator_highlight = { 'NONE', stl_bg },
          highlight = { colors.green, stl_bg },
        },
      }
      gls.right[4] = {
        ShowLspClient = {
          provider = 'GetLspClient',
          condition = function()
            local tbl = { ['dashboard'] = true, [''] = true }
            if tbl[vim.bo.filetype] then
              return false
            end
            return true
          end,
          separator = ' ',
          separator_highlight = { 'NONE', stl_bg },
          highlight = { colors.cyan, stl_bg },
        },
      }
      gls.right[5] = {
        GitIcon = {
          provider = function()
            return ' '
          end,
          condition = condition.check_git_workspace,
          separator = ' ',
          separator_highlight = { 'NONE', stl_bg },
          highlight = { colors.purple, stl_bg, 'bold' },
        },
      }
      gls.right[6] = {
        GitBranch = {
          provider = 'GitBranch',
          condition = condition.check_git_workspace,
          highlight = { colors.purple, stl_bg, 'bold' },
        },
      }
      gls.right[7] = {
        DiffAdd = {
          provider = 'DiffAdd',
          condition = condition.hide_in_width,
          icon = '  ',
          separator = ' ',
          separator_highlight = { 'NONE', stl_bg },
          highlight = { colors.green, stl_bg },
        },
      }
      gls.right[8] = {
        DiffModified = {
          provider = 'DiffModified',
          condition = condition.hide_in_width,
          icon = '  ',
          highlight = { colors.yellow, stl_bg },
        },
      }
      gls.right[9] = {
        DiffRemove = {
          provider = 'DiffRemove',
          condition = condition.hide_in_width,
          icon = '  ',
          highlight = { colors.red, stl_bg },
        },
      }
      gls.right[10] = {
        RainbowBlue = {
          provider = function()
            return ' ▊'
          end,
          highlight = { colors.blue, stl_bg },
        },
      }

      gls.short_line_left[1] = {
        FileIcon = {
          provider = 'FileIcon',
          separator = ' ',
          condition = condition.buffer_not_empty,
          highlight = { colors.fg, stl_bg },
        },
      }
      gls.short_line_left[2] = {
        SFileName = {
          provider = 'SFileName',
          condition = condition.buffer_not_empty,
          highlight = { colors.fg, stl_bg },
        },
      }

      gls.short_line_right[1] = { BufferIcon = { provider = 'BufferIcon', highlight = { colors.fg, stl_bg } } }
    end,
  },
}
