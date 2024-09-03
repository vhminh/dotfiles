---@class Colors
--- Color fields extracted from https://github.com/navarasu/onedark.nvim/blob/fae34f7c635797f4bf62fb00e7d0516efa8abe37/lua/onedark/palette.lua#L2
---@field black string
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field fg string
---@field purple string
---@field green string
---@field orange string
---@field blue string
---@field yellow string
---@field cyan string
---@field red string
---@field grey string
---@field light_grey string
---@field dark_cyan string
---@field dark_red string
---@field dark_yellow string
---@field dark_purple string

---@type Colors
local colors = require('onedark.palette')['warm']

return colors
