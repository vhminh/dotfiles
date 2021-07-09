-- Define my colors
local my_color = require('my-color')
local colors = {
	yellow = {
		actual = my_color.yellow,
		compare = '#ff0',
	},
	green = {
		actual = my_color.green,
		compare = '#00ff00',
	},
	blue = {
		actual = my_color.blue,
		compare = '#0000ff',
	},
	red = {
		actual = my_color.red,
		compare = '#ff0000',
	},
}

local plugin = require('nvim-web-devicons')

-- Load default icon
local icons = plugin.get_icons()

function hex2rgb(hex)
	local hex = hex:gsub("#","")
	if hex:len() == 3 then
		return (tonumber("0x"..hex:sub(1, 1)) * 17), (tonumber("0x"..hex:sub(2, 2)) * 17), (tonumber("0x"..hex:sub(3, 3)) * 17)
	else
		return tonumber("0x"..hex:sub(1, 2)), tonumber("0x"..hex:sub(3, 4)), tonumber("0x"..hex:sub(5, 6))
	end
end

function color_diff(color1, color2)
	local r1, g1, b1 = hex2rgb(color1)
	local x1, y1 = r1 - g1, r1 - b1
	local r2, g2, b2 = hex2rgb(color2)
	local x2, y2 = r2 - g2, r2 - b2
	return math.abs(x1 - x2) + math.abs(y1 - y2)
end

-- Modify colors
for key, val in pairs(icons) do
	local nearest_color = colors.blue
	for _, color in pairs(colors) do
		if color_diff(val.color, nearest_color.compare) > color_diff(val.color, color.compare) then
			nearest_color = color
		end
	end
	icons[key].color = nearest_color.actual
end

plugin.setup {
	override = icons
}
