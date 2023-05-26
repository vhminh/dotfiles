-- override onedark gui values with corresponding cterm values (except for dark_red, cyan, and special_grey)
local raw = {
  red = { gui = '#ff5f87', cterm = '204', cterm16 = '1' },
  dark_red = { gui = '#be5046', cterm = '196', cterm16 = '9' }, -- use default onedark gui color
  green = { gui = '#87d787', cterm = '114', cterm16 = '2' },
  yellow = { gui = '#d7af87', cterm = '180', cterm16 = '3' },
  dark_yellow = { gui = '#d7875f', cterm = '173', cterm16 = '11' },
  blue = { gui = '#00afff', cterm = '39', cterm16 = '4' },
  purple = { gui = '#d75fd7', cterm = '170', cterm16 = '5' },
  cyan = { gui = '#56b6c2', cterm = '38', cterm16 = '6' }, -- use default onedark gui color
  white = { gui = '#afafaf', cterm = '145', cterm16 = '15' },
  black = { gui = '#262626', cterm = '235', cterm16 = '0' },
  foreground = { gui = '#afafaf', cterm = '145', cterm16 = 'NONE' },
  background = { gui = '#262626', cterm = '235', cterm16 = 'NONE' },
  comment_grey = { gui = '#5f5f5f', cterm = '59', cterm16 = '7' },
  gutter_fg_grey = { gui = '#444444', cterm = '238', cterm16 = '8' },
  cursor_grey = { gui = '#303030', cterm = '236', cterm16 = '0' },
  visual_grey = { gui = '#3a3a3a', cterm = '237', cterm16 = '8' },
  menu_grey = { gui = '#3a3a3a', cterm = '237', cterm16 = '7' },
  special_grey = { gui = '#3b4048', cterm = '238', cterm16 = '7' }, -- use default onedark gui color
  vertsplit = { gui = '#5f5f5f', cterm = '59', cterm16 = '7' },
}

local gui_colors = {}

for k, v in pairs(raw) do
  gui_colors[k] = v.gui
end

return {
  raw = raw,
  colors = gui_colors,
  gui = gui_colors,
}
