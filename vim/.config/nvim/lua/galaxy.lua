-- colors
local colors = {
	bg = '#2e2e2e',
	fg = '#abb2bf',
	yellow = '#e5c07b',
	cyan = '#56b6c2',
	green = '#98c379',
	magenta = '#c678dd',
	blue = '#61afef',
	red = '#e06c75';
}

-- some util functions
local get_mode_color = function(mode)
	local mode_color = {
		n = colors.blue, i = colors.green,v = colors.yellow,
		[''] = colors.yellow, V = colors.yellow,
		c = colors.magenta, no = colors.blue, s = colors.yellow,
		S = colors.yellow, [''] = colors.yellow,
		ic = colors.green, R = colors.red, Rv = colors.red,
		cv = colors.fg, ce = colors.fg, r = colors.fg,
		rm = colors.fg, ['r?'] = colors.fg,
		['!']  = colors.magenta, t = colors.magenta
	}
	return mode_color[mode]
end

local get_mode_text = function(mode)
	local mode_text = {
		n = 'NORMAL', i = "INSERT", v = 'VISUAL',
		[''] = 'V-BLOCK', V = 'V-LINE',
		c = 'COMMAND', no = 'OPERATOR', s = 'SELECT',
		S= 'S-LINE', [''] = 'S-BLOCK',
		ic = 'COMPLETION', R = 'REPLACE', Rv = 'VIRT-REPLACE',
		cv = 'EX', ce = 'EX-NORMAL', r = 'ENTER-PROMPT',
		rm = 'MORE_PROMPT', ['r?'] = 'CONFIRM',
		['!']  = 'SHELL', t = 'TERM'
	}
	return mode_text[mode]
end

local get_os_logo = function()
	local icon
	if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 or vim.fn.has('win16') == 1 then
		icon = ''
	else
		local f = assert(io.popen('uname', 'r'))
		local os = assert(f:read('*a'))
		os = string.gsub(os, '^%s+', '')
		os = string.gsub(os, '%s+$', '')
		os = string.gsub(os, '[\n\r]+', ' ')
		if os == 'Linux' then
			icon = ''
		elseif os == 'Darwin' then
			icon = ''
		elseif os == 'FreeBSD' then
			icon = ''
		else
			icon = ''
		end
	end
	return icon
end

local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = {'NvimTree','vista','dbui'}

local os_logo = get_os_logo()

gls.left[1] = {
	ViMode = {
		provider = function()
			local mode = vim.fn.mode()
			vim.api.nvim_command('hi GalaxyViMode guifg='..colors.bg..' guibg='..get_mode_color(mode))
			return '  '..os_logo..' '..get_mode_text(mode)..' '
		end,
		highlight = {colors.red,colors.bg},
	},
}

gls.left[2] = {
	Separator = {
		provider = function() return ' ' end,
		highlight = {colors.fg, colors.bg}
	},
}

gls.left[3] = {
	FileIcon = {
		provider = 'FileIcon',
		condition = condition.buffer_not_empty,
		highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
	},
}

gls.left[4] = {
	FileName = {
		provider = {'FileName'},
		condition = condition.buffer_not_empty,
		highlight = {colors.magenta,colors.bg}
	}
}

gls.left[5] = {
	Function = {
		provider = function ()
			local fn_name = vim.api.nvim_eval("get(b:, 'vista_nearest_method_or_function', '')")
			if fn_name == "" then
				return ""
			end
			return ': ' .. fn_name
		end,
		separator = ' ',
		separator_highlight = {'NONE',colors.bg},
		highlight = {colors.fg,colors.bg},
	},
}

gls.left[6] = {
	DiagnosticError = {
		provider = 'DiagnosticError',
		icon = '  ',
		highlight = {colors.red,colors.bg}
	}
}
gls.left[7] = {
	DiagnosticWarn = {
		provider = 'DiagnosticWarn',
		icon = '  ',
		highlight = {colors.yellow,colors.bg},
	}
}

gls.left[8] = {
	DiagnosticHint = {
		provider = 'DiagnosticHint',
		icon = '  ',
		highlight = {colors.cyan,colors.bg},
	}
}

gls.left[9] = {
	DiagnosticInfo = {
		provider = 'DiagnosticInfo',
		icon = '  ',
		highlight = {colors.blue,colors.bg},
	}
}


-- gls.right[1] = {
-- 	LineInfo = {
-- 		provider = 'LineColumn',
-- 		separator = ' ',
-- 		separator_highlight = {'NONE',colors.bg},
-- 		highlight = {colors.fg,colors.bg},
-- 	},
-- }
gls.right[1] = {
	TotalLines = {
		provider = function () return vim.api.nvim_buf_line_count(0) .. ' lines' end,
		separator = ' ',
		separator_highlight = {'NONE',colors.bg},
		highlight = {colors.fg,colors.bg},
	}
}

gls.right[2] = {
	PerCent = {
		provider = 'LinePercent',
		separator = ' ',
		separator_highlight = {'NONE',colors.bg},
		highlight = {colors.fg,colors.bg},
	}
}

gls.right[3] = {
	FileEncode = {
		provider = 'FileEncode',
		separator = ' ',
		separator_highlight = {'NONE',colors.bg},
		highlight = {colors.green,colors.bg}
	}
}

gls.right[4] = {
	FileFormat = {
		provider = 'FileFormat',
		separator = ' ',
		separator_highlight = {'NONE',colors.bg},
		highlight = {colors.green,colors.bg}
	}
}

gls.right[5] = {
	ShowLspClient = {
		provider = 'GetLspClient',
		condition = function ()
			local tbl = {['dashboard'] = true,['']=true}
			if tbl[vim.bo.filetype] then
				return false
			end
			return true
		end,
		separator = ' ',
		separator_highlight = {'NONE',colors.bg},
		highlight = {colors.cyan,colors.bg}
	}
}

gls.right[6] = {
	GitIcon = {
		provider = function() return '  ' end,
		condition = condition.check_git_workspace,
		separator = ' ',
		separator_highlight = {'NONE',colors.bg},
		highlight = {colors.magenta,colors.bg,'bold'},
	}
}

gls.right[7] = {
	GitBranch = {
		provider = 'GitBranch',
		condition = condition.check_git_workspace,
		highlight = {colors.magenta,colors.bg,'bold'},
	}
}

gls.right[8] = {
	DiffAdd = {
		provider = 'DiffAdd',
		condition = condition.hide_in_width,
		icon = '  ',
		highlight = {colors.green,colors.bg},
	}
}
gls.right[9] = {
	DiffModified = {
		provider = 'DiffModified',
		condition = condition.hide_in_width,
		icon = ' 柳',
		highlight = {colors.yellow,colors.bg},
	}
}
gls.right[10] = {
	DiffRemove = {
		provider = 'DiffRemove',
		condition = condition.hide_in_width,
		icon = '  ',
		highlight = {colors.red,colors.bg},
	}
}

gls.right[11] = {
	RainbowBlue = {
		provider = function() return ' ▊' end,
		highlight = {colors.blue,colors.bg}
	},
}

gls.short_line_left[1] = {
	FileIcon = {
		provider = 'FileIcon',
		separator = ' ',
		condition = condition.buffer_not_empty,
		highlight = {colors.fg,colors.bg},
	},
}

gls.short_line_left[2] = {
	SFileName = {
		provider = 'SFileName',
		condition = condition.buffer_not_empty,
		highlight = {colors.fg,colors.bg}
	}
}

gls.short_line_right[1] = {
	BufferIcon = {
		provider= 'BufferIcon',
		highlight = {colors.fg,colors.bg}
	}
}

