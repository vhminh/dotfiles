local colors = require('colors').gui
local navic = require('nvim-navic')

local colors_by_mode = {
  n = colors.blue, i = colors.green, v = colors.yellow,
  [''] = colors.yellow, V = colors.yellow,
  c = colors.purple, no = colors.blue, s = colors.yellow,
  S = colors.yellow, [''] = colors.yellow,
  ic = colors.green, R = colors.red, Rv = colors.red,
  cv = colors.foreground, ce = colors.foreground, r = colors.foreground,
  rm = colors.foreground, ['r?'] = colors.foreground,
  ['!'] = colors.purple, t = colors.purple
}
local get_mode_color = function(mode)
  return colors_by_mode[mode]
end

local text_by_mode = {
  n = 'NORMAL', i = 'INSERT', v = 'VISUAL',
  [''] = 'V-BLOCK', V = 'V-LINE',
  c = 'COMMAND', no = 'OPERATOR', s = 'SELECT',
  S = 'S-LINE', [''] = 'S-BLOCK',
  ic = 'COMPLETION', R = 'REPLACE', Rv = 'VIRT-REPLACE',
  cv = 'EX', ce = 'EX-NORMAL', r = 'ENTER-PROMPT',
  rm = 'MORE_PROMPT', ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL', t = 'TERM'
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
      vim.api.nvim_command('hi GalaxyViMode guifg=' .. colors.background .. ' guibg=' .. get_mode_color(mode))
      return '  ' .. get_mode_text(mode) .. ' '
    end,
    highlight = { colors.red, colors.background },
  },
}
gls.left[2] = { Separator = { provider = function() return ' ' end, highlight = { colors.foreground, colors.grey } } }
gls.left[3] = {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = { require('galaxyline.providers.fileinfo').get_file_icon_color, colors.grey },
  },
}
gls.left[4] = {
  FileName = {
    provider = { 'FileName' },
    condition = condition.buffer_not_empty,
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.purple, colors.grey }
  }
}
gls.left[5] = {
  Function = {
    condition = navic.is_available(),
    provider = function()
      return navic.get_location()
    end,
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
  },
}
gls.left[6] = { DiagnosticError = { provider = 'DiagnosticError', icon = '  ', highlight = { colors.red, colors.grey } } }
gls.left[7] = { DiagnosticWarn = { provider = 'DiagnosticWarn', icon = '  ',
  highlight = { colors.yellow, colors.grey } } }
gls.left[8] = { DiagnosticHint = { provider = 'DiagnosticHint', icon = '  ', highlight = { colors.cyan, colors.grey } } }
gls.left[9] = { DiagnosticInfo = { provider = 'DiagnosticInfo', icon = '  ', highlight = { colors.blue, colors.grey } } }

gls.right[1] = {
  TotalLines = {
    provider = function()
      local cur_line_num = vim.api.nvim_win_get_cursor(0)[1]
      local line_count = vim.api.nvim_buf_line_count(0)
      return cur_line_num .. ' / ' .. line_count
    end,
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.foreground, colors.grey },
  }
}
gls.right[2] = {
  FileEncode = {
    provider = 'FileEncode',
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.green, colors.grey }
  }
}
gls.right[3] = {
  FileFormat = {
    provider = 'FileFormat',
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.green, colors.grey }
  }
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
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.cyan, colors.grey }
  }
}
gls.right[5] = {
  GitIcon = {
    provider = function() return ' ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.purple, colors.grey, 'bold' },
  }
}
gls.right[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = { colors.purple, colors.grey, 'bold' },
  }
}
gls.right[7] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.green, colors.grey },
  }
}
gls.right[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = { colors.yellow, colors.grey },
  }
}
gls.right[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = { colors.red, colors.grey },
  }
}
gls.right[10] = { RainbowBlue = { provider = function() return ' ▊' end, highlight = { colors.blue, colors.grey } }, }

gls.short_line_left[1] = {
  FileIcon = {
    provider = 'FileIcon',
    separator = ' ',
    condition = condition.buffer_not_empty,
    highlight = { colors.foreground, colors.grey },
  },
}
gls.short_line_left[2] = {
  SFileName = {
    provider = 'SFileName',
    condition = condition.buffer_not_empty,
    highlight = { colors.foreground, colors.grey }
  }
}

gls.short_line_right[1] = { BufferIcon = { provider = 'BufferIcon', highlight = { colors.foreground, colors.grey } } }
