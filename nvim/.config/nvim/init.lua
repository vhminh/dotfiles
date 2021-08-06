vim.opt.termguicolors = true
vim.g.mapleader = ' '


----------------------------------------
-- PACKER                              -
----------------------------------------
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

local need_install_plugin = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	need_install_plugin = true
	print("Cloning packer.nvim")
	vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	print("Packadd packer.nvim")
	vim.api.nvim_command 'packadd packer.nvim'
	print("Done")
end

if vim._update_package_paths then
	vim._update_package_paths()
end

vim.cmd([[autocmd BufWritePost init.lua source <afile> | PackerCompile]])

local packer = require('packer')
local use = packer.use
packer.startup(function()
	use 'wbthomason/packer.nvim'
	use 'joshdick/onedark.vim'
	use 'neovim/nvim-lspconfig'
	use 'nvim-lua/completion-nvim'
	use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
	use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
	use 'junegunn/fzf.vim'
	use 'windwp/nvim-autopairs'
	use 'tpope/vim-commentary'
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use { 'glepnir/galaxyline.nvim', requires = 'kyazdani42/nvim-web-devicons' }
	use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
	use 'liuchengxu/vista.vim'
	use 'onsails/lspkind-nvim'
end)

if need_install_plugin then
	vim.api.nvim_command 'PackerSync'
end
vim.api.nvim_command 'PackerInstall'


----------------------------------------
-- COLOR SCHEME                        -
----------------------------------------
-- override some color
-- prefer some color from cterm instead of gui
vim.g['onedark_color_overrides'] = {
	background = { gui = "#262626", cterm = "235", cterm16 = "0" },
	cursor_grey = { gui = "#303030", cterm = "236", cterm16 = "0" },
	visual_grey = { gui = "#3a3a3a", cterm = "237", cterm16 = "8" },
	vertsplit = { gui = "#5f5f5f", cterm = "59", cterm16 = "7" },
}

vim.api.nvim_exec([[
if (has("autocmd") && !has("gui_running"))
	augroup colorextend
	autocmd!
	let colors = onedark#GetColors()
	autocmd ColorScheme * call onedark#extend_highlight("Keyword", { "fg": colors.purple })
	augroup END
	endif
	]], false)
vim.cmd [[colorscheme onedark]]

-- extract color to use in other plugins
local onedarkColors = vim.api.nvim_eval('onedark#GetColors()')
local colors = {
	bg = onedarkColors.background,
	fg = onedarkColors.foreground,
	yellow = onedarkColors.yellow,
	cyan = onedarkColors.cyan,
	green = onedarkColors.green,
	purple = onedarkColors.purple,
	blue = onedarkColors.blue,
	red = onedarkColors.red,
	grey = onedarkColors.cursor_grey,
}
local get_display_color = function (color)
	if vim.opt.termguicolors then
		return color.gui
	end
return color.cterm
end
-- for now just use termguicolors option set when start vim
-- does not provide reload in runtime
for k, v in pairs(colors) do
	colors[k] = get_display_color(v)
end


----------------------------------------
-- NVIM TREE                           -
----------------------------------------
vim.api.nvim_set_keymap('n', '<leader>n', '<Cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })


----------------------------------------
-- LSP                                 -
----------------------------------------
-- Lsp completion settings
vim.opt.completeopt={ 'menuone', 'noinsert', 'noselect' }
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
-- Define signs
vim.fn.sign_define('LspDiagnosticsSignError', {
	text = '',
	texthl = 'LspDiagnosticsSignError',
})

vim.fn.sign_define('LspDiagnosticsSignWarning', {
	text = '',
	texthl = 'LspDiagnosticsSignWarning',
})

vim.fn.sign_define('LspDiagnosticsSignInformation', {
	text = '',
	texthl = 'LspDiagnosticsSignInformation',
})

vim.fn.sign_define('LspDiagnosticsSignHint', {
	text = '',
	texthl = 'LspDiagnosticsSignHint'
})

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local opts = { noremap=true, silent=true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	-- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts) -- leaving this one commented and mapping gr to view lsp references in trouble.nvim
	buf_set_keymap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

	buf_set_keymap('n', '<leader>lca', '<cmd>lua print(vim.inspect(vim.lsp.buf.code_action()))<CR>', opts)
	-- mouse mapping
	buf_set_keymap('n', '<C-LeftMouse>', '<LeftMouse> <cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', '<RightMouse>', '<LeftMouse> <cmd>lua vim.inspect(vim.lsp.buf.code_action())<CR>', opts)

	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities.document_formatting then
		buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
	elseif client.resolved_capabilities.document_range_formatting then
		buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
	end

	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec([[
		hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
		hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
		hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
		augroup lsp_document_highlight
		autocmd! * <buffer>
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		augroup END
		]], false)
	end

	-- Completion
	local completion = require('completion')
	completion.on_attach()

	-- LSP kind
	local lspkind = require('lspkind')
	lspkind.init({
		with_text = true,
		symbol_map = {
			Text = '',
			Method = 'ƒ',
			Function = '',
			Constructor = '',
			Variable = '',
			Class = '',
			Interface = 'ﰮ',
			Module = '',
			Property = '',
			Unit = '',
			Value = '',
			Enum = '了',
			Keyword = '',
			Snippet = '﬌',
			Color = '',
			File = '',
			Folder = '',
			EnumMember = '',
			Constant = '',
			Struct = ''
		},
	})
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { 'clangd', 'gopls', 'pyright', 'tsserver', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup { on_attach = on_attach }
end


----------------------------------------
-- FZF                                 -
----------------------------------------
vim.api.nvim_set_keymap('n', '<C-f>', '<Cmd>Files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', '<Cmd>Files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b', '<Cmd>Buffers<CR>', { noremap = true, silent = true })
if vim.fn.executable('rg') ~= 0 then
	vim.api.nvim_command[[
	function! RipgrepFzf(query, fullscreen)
	let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!{.git,node_modules}" -- %s || true'
	let initial_command = printf(command_fmt, shellescape(a:query))
	let reload_command = printf(command_fmt, '{q}')
	let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
	call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
	endfunction

	command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
	]]
	vim.api.nvim_command[[command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!{.git,node_modules}" '.shellescape(<q-args>), 1, <bang>0)]]
	vim.env['FZF_DEFAULT_COMMAND'] = 'rg --files --hidden -g "!{.git,node_modules}"'
	vim.api.nvim_set_keymap('n', '<leader>g', '<Cmd>RG<CR>', { noremap = true, silent = true })
elseif vim.fn.executable('ag') ~= 0 then
	vim.api.nvim_set_keymap('n', '<leader>g', '<Cmd>Ag<CR>', { noremap = true, silent = true })
end


----------------------------------------
-- NVIM AUTOPAIRS                      -
----------------------------------------
require('nvim-autopairs').setup{}


----------------------------------------
-- GIT SIGNS                           -
----------------------------------------
require('gitsigns').setup {
	signs = {
		add = { hl = 'GitGutterAdd', text = '+' },
		change = { hl = 'GitGutterChange', text = '~' },
		delete = { hl = 'GitGutterDelete', text = '_' },
		topdelete = { hl = 'GitGutterDelete', text = '‾' },
		changedelete = { hl = 'GitGutterChange', text = '~' },
	},
	current_line_blame = true,
	keymaps = {
		noremap = true,
		['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
		['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
		['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
		['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
		['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
		['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
		['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
		['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
	},
}


----------------------------------------
-- TREESITTER                          -
----------------------------------------
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained",
	highlight = {
		enable = true,
	},
}


----------------------------------------
-- GALAXY LINE                         -
----------------------------------------
-- some util functions
local get_mode_color = function(mode)
	local mode_color = {
		n = colors.blue, i = colors.green,v = colors.yellow,
		[''] = colors.yellow, V = colors.yellow,
		c = colors.purple, no = colors.blue, s = colors.yellow,
		S = colors.yellow, [''] = colors.yellow,
		ic = colors.green, R = colors.red, Rv = colors.red,
		cv = colors.fg, ce = colors.fg, r = colors.fg,
		rm = colors.fg, ['r?'] = colors.fg,
		['!']  = colors.purple, t = colors.purple
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
		return ''
	end
	local f = assert(io.popen('uname', 'r'))
	local os = assert(f:read('*a'))
	os = string.gsub(os, '^%s+', '')
	os = string.gsub(os, '%s+$', '')
	os = string.gsub(os, '[\n\r]+', ' ')
	if os == 'Linux' then
		return ''
	end
	if os == 'Darwin' then
		return ''
	end
	if os == 'FreeBSD' then
		return ''
	end
	return ''
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
		highlight = {colors.fg, colors.grey}
	},
}

gls.left[3] = {
	FileIcon = {
		provider = 'FileIcon',
		condition = condition.buffer_not_empty,
		highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.grey},
	},
}

gls.left[4] = {
	FileName = {
		provider = {'FileName'},
		condition = condition.buffer_not_empty,
		highlight = {colors.purple,colors.grey}
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
		separator_highlight = {'NONE',colors.grey},
		highlight = {colors.fg,colors.grey},
	},
}

gls.left[6] = {
	DiagnosticError = {
		provider = 'DiagnosticError',
		icon = '  ',
		highlight = {colors.red,colors.grey}
	}
}
gls.left[7] = {
	DiagnosticWarn = {
		provider = 'DiagnosticWarn',
		icon = '  ',
		highlight = {colors.yellow,colors.grey},
	}
}

gls.left[8] = {
	DiagnosticHint = {
		provider = 'DiagnosticHint',
		icon = '  ',
		highlight = {colors.cyan,colors.grey},
	}
}

gls.left[9] = {
	DiagnosticInfo = {
		provider = 'DiagnosticInfo',
		icon = '  ',
		highlight = {colors.blue,colors.grey},
	}
}

gls.right[1] = {
	TotalLines = {
		provider = function () 
			local cur_line_num = vim.api.nvim_win_get_cursor(0)[1]
			local line_count = vim.api.nvim_buf_line_count(0)
			return cur_line_num .. ' / ' .. line_count
		end,
		separator_highlight = {'NONE',colors.grey},
		highlight = {colors.fg,colors.grey},
	}
}

gls.right[2] = {
	FileEncode = {
		provider = 'FileEncode',
		separator = ' ',
		separator_highlight = {'NONE',colors.grey},
		highlight = {colors.green,colors.grey}
	}
}

gls.right[3] = {
	FileFormat = {
		provider = 'FileFormat',
		separator = ' ',
		separator_highlight = {'NONE',colors.grey},
		highlight = {colors.green,colors.grey}
	}
}

gls.right[4] = {
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
		separator_highlight = {'NONE',colors.grey},
		highlight = {colors.cyan,colors.grey}
	}
}

gls.right[5] = {
	GitIcon = {
		provider = function() return '  ' end,
		condition = condition.check_git_workspace,
		separator = ' ',
		separator_highlight = {'NONE',colors.grey},
		highlight = {colors.purple,colors.grey,'bold'},
	}
}

gls.right[6] = {
	GitBranch = {
		provider = 'GitBranch',
		condition = condition.check_git_workspace,
		highlight = {colors.purple,colors.grey,'bold'},
	}
}

gls.right[7] = {
	DiffAdd = {
		provider = 'DiffAdd',
		condition = condition.hide_in_width,
		icon = '  ',
		highlight = {colors.green,colors.grey},
	}
}
gls.right[8] = {
	DiffModified = {
		provider = 'DiffModified',
		condition = condition.hide_in_width,
		icon = ' 柳',
		highlight = {colors.yellow,colors.grey},
	}
}
gls.right[9] = {
	DiffRemove = {
		provider = 'DiffRemove',
		condition = condition.hide_in_width,
		icon = '  ',
		highlight = {colors.red,colors.grey},
	}
}

gls.right[10] = {
	RainbowBlue = {
		provider = function() return ' ▊' end,
		highlight = {colors.blue,colors.grey}
	},
}

gls.short_line_left[1] = {
	FileIcon = {
		provider = 'FileIcon',
		separator = ' ',
		condition = condition.buffer_not_empty,
		highlight = {colors.fg,colors.grey},
	},
}

gls.short_line_left[2] = {
	SFileName = {
		provider = 'SFileName',
		condition = condition.buffer_not_empty,
		highlight = {colors.fg,colors.grey}
	}
}

gls.short_line_right[1] = {
	BufferIcon = {
		provider= 'BufferIcon',
		highlight = {colors.fg,colors.grey}
	}
}


----------------------------------------
-- VISTA                               -
----------------------------------------
vim.g.vista_default_executive = 'nvim_lsp'
vim.api.nvim_set_keymap('n', '<leader>t', '<Cmd>Vista!!<CR>', { noremap = true, silent = true })


----------------------------------------
-- CUSTOM SETTINGS                     -
----------------------------------------
-- TODO: port to lua later
--
vim.api.nvim_command[[
syntax on
set listchars=tab:>·,trail:~
set list
set fillchars=vert:\|
hi vertsplit guifg=Gray guibg=bg

filetype plugin indent on

set foldmethod=indent
set foldlevelstart=99

set splitbelow
set splitright

set hidden
set encoding=utf8
set nowrap
set showcmd
set clipboard=unnamedplus
set showmatch
set backspace=indent,eol,start
set smartindent
set autoread
set autowriteall
set ignorecase
set smartcase
set hlsearch
set incsearch
set mouse=a
set noexpandtab
set shiftwidth=4
set tabstop=4
set scrolloff=5
set number
set relativenumber
set cursorline
set noshowmode

nnoremap <C-c> :nohlsearch<CR>
nnoremap <ESC> :nohlsearch<CR>

map <C-c> <ESC>
imap <C-c> <ESC>

nmap Y y$

vmap < <gv
vmap > >gv

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

nnoremap <C-w><C-h> :vertical resize -2<CR>
nnoremap <C-w><C-j> :resize -2<CR>
nnoremap <C-w><C-k> :resize +2<CR>
nnoremap <C-w><C-l> :vertical resize +2<CR>

nnoremap k gk
nnoremap j gj
nnoremap <C-q> :quit<CR>
]]

