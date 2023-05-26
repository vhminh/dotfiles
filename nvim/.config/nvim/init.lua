vim.g.mapleader = ' '

----------------------------------------------------------------
-- PACKER
----------------------------------------------------------------

local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local need_install_plugin = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  need_install_plugin = true
  print('Cloning packer.nvim')
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
  print('Packadd packer.nvim')
  vim.api.nvim_command 'packadd packer.nvim'
  print('Done')
end

if vim._update_package_paths then
  vim._update_package_paths()
end

local packer = require('packer')
local use = packer.use
packer.startup(function()
  use 'wbthomason/packer.nvim'
  use 'joshdick/onedark.vim'
  use 'neovim/nvim-lspconfig'
  use { 'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets' } }
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }
  use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-commentary'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use { 'NTBBloodbath/galaxyline.nvim', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'justinmk/vim-sneak'
  use 'liuchengxu/vista.vim'
  use 'onsails/lspkind-nvim'
  use 'SmiteshP/nvim-navic'
  use 'folke/neodev.nvim'
  use 'editorconfig/editorconfig-vim'
  use { 'scalameta/nvim-metals', requires = { 'nvim-lua/plenary.nvim' } }
end)

if need_install_plugin then
  vim.api.nvim_command 'PackerSync'
end
vim.api.nvim_command 'PackerInstall'


----------------------------------------------------------------
-- ONE DARK
----------------------------------------------------------------

-- override onedark gui values with corresponding cterm values (except for dark_red, cyan, and special_grey)
vim.g['onedark_color_overrides'] = {
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

vim.cmd([[
if (has('autocmd') && !has('gui_running'))
augroup colorextend
autocmd!
let colors = onedark#GetColors()
autocmd ColorScheme * call onedark#extend_highlight('Keyword', { 'fg': colors.purple })
augroup END
endif
]])

vim.cmd([[
augroup highlight_vertsplit
autocmd!
autocmd Colorscheme * highlight vertsplit guifg=Gray guibg=bg
augroup END
]])

-- extract colors to use in other plugins
local colors = vim.api.nvim_eval('onedark#GetColors()')
for k, v in pairs(colors) do
  colors[k] = v.gui
end


----------------------------------------------------------------
-- NVIM TREE
----------------------------------------------------------------

require 'nvim-tree'.setup {
  diagnostics = {
    enable = true,
  },
  renderer = {
    group_empty = true,
  },
}
vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>')


----------------------------------------------------------------
-- LSP
----------------------------------------------------------------

-- completion with lspkind
local lspkind = require('lspkind')
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.completion_trigger_on_delete = true
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  }),
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
    })
  },
})

-- define lsp signs
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

local navic = require('nvim-navic')
navic.setup {
  highlight = false,
}

local on_attach = function(client, bufnr)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { remap = false, silent = false, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)

  vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, bufopts)

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
    hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]])
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

end

-- install language servers
local servers = { 'lua_ls', 'gopls', 'clangd', 'pyright' }
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = servers,
}

-- neodev for init.lua
require('neodev').setup({})

-- setup language servers
for _, server in pairs(servers) do
  local opt = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
  require('lspconfig')[server].setup(opt)
end

-- metals
local metals_config = require('metals').bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
}
metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()
metals_config.on_attach = on_attach
local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt', 'java' },
  callback = function()
    require('metals').initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})


----------------------------------------------------------------
-- TELESCOPE
----------------------------------------------------------------

require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '-g',
      '!{.git,node_modules}',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}
require('telescope').load_extension('fzf')
local telescope_builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>a', telescope_builtin.builtin)
-- files and finders
vim.keymap.set('n', '<C-f>', function()
  telescope_builtin.find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!{.git,node_modules}" } })
end)
vim.keymap.set('n', '<leader>f', function()
  telescope_builtin.find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!{.git,node_modules}" } })
end)
vim.keymap.set('n', '<leader>b', telescope_builtin.buffers)
vim.keymap.set('n', '<leader>g', telescope_builtin.live_grep)
-- lsp
vim.keymap.set('n', 'gr', telescope_builtin.lsp_references)
vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', '<leader>d', telescope_builtin.diagnostics)
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations)


----------------------------------------------------------------
-- AUTOPAIRS
----------------------------------------------------------------

require('nvim-autopairs').setup {}


----------------------------------------------------------------
-- GIT SIGNS
----------------------------------------------------------------

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
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<Cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
    ['n [c'] = { expr = true, "&diff ? '[c' : '<Cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },
    ['n <leader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <leader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hu'] = '<Cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hR'] = '<Cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>hp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>hb'] = '<Cmd>lua require"gitsigns".blame_line(true)<CR>',
  },
}


----------------------------------------------------------------
-- TREESITTER
----------------------------------------------------------------

vim.cmd('autocmd ColorScheme * highlight TSTypeBuiltin guifg=' .. colors.purple)
vim.cmd('autocmd ColorScheme * highlight TSFuncBuiltin guifg=' .. colors.cyan)
vim.cmd('autocmd ColorScheme * highlight TSPackageName guifg=' .. colors.white)

local treesitter_ensure_installed = { 'bash', 'c', 'c_sharp', 'cmake', 'comment', 'cpp', 'css', 'cuda', 'dart', 'diff',
  'dockerfile', 'fish', 'gdscript', 'gitattributes', 'gitignore', 'go', 'godot_resource', 'gomod', 'gowork', 'graphql',
  'haskell', 'help', 'hjson', 'html', 'java', 'javascript', 'jsdoc', 'json', 'json5', 'kotlin', 'latex', 'llvm', 'lua',
  'make', 'markdown', 'markdown_inline', 'meson', 'ninja', 'nix', 'pascal', 'perl', 'php', 'phpdoc', 'proto', 'python',
  'r', 'regex', 'ruby', 'rust', 'scala', 'scss', 'sql', 'swift', 'toml', 'tsx', 'typescript', 'vala', 'vim', 'yaml',
  'zig' }

require 'nvim-treesitter.configs'.setup {
  ensure_installed = treesitter_ensure_installed,
  highlight = {
    enable = true,
    custom_captures = {
      ['package.name'] = 'TSPackageName',
    },
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}


----------------------------------------------------------------
-- SNEAK
----------------------------------------------------------------

vim.g['sneak#label'] = true
vim.g['sneak#prompt'] = ' '
vim.keymap.set('n', 'f', '<Plug>Sneak_f')
vim.keymap.set('n', 'F', '<Plug>Sneak_F')
vim.keymap.set('n', 't', '<Plug>Sneak_t')
vim.keymap.set('n', 'T', '<Plug>Sneak_T')

vim.cmd([[
augroup sneak_highlight
autocmd!
autocmd ColorScheme * highlight Sneak guifg=]] .. colors.background .. ' guibg=' .. colors.yellow .. [[

autocmd ColorScheme * highlight SneakLabel guifg=]] .. colors.foreground .. ' guibg=' .. colors.yellow .. [[

augroup END
]])


----------------------------------------------------------------
-- GALAXY LINE
----------------------------------------------------------------

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
    icon = '  ',
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.green, colors.grey },
  }
}
gls.right[8] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = { colors.yellow, colors.grey },
  }
}
gls.right[9] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
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


----------------------------------------------------------------
-- VISTA
----------------------------------------------------------------

vim.g.vista_default_executive = 'nvim_lsp'
vim.keymap.set('n', '<leader>t', '<Cmd>Vista!!<CR>')


----------------------------------------------------------------
-- VIM OPTS
----------------------------------------------------------------

-- <C-c> as <ESC>
vim.keymap.set('', '<C-c>', '<ESC>', { remap = true })
vim.keymap.set('i', '<C-c>', '<ESC>', { remap = true })

-- indent
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

-- visual
vim.opt.termguicolors = true
vim.opt.listchars = { tab = '» ', trail = '~', }
vim.opt.list = true
vim.opt.fillchars = { vert = '|', }
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.wrap = false
vim.opt.showmatch = true
vim.opt.showcmd = true
vim.opt.showmode = false

-- behavior
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.clipboard = { 'unnamedplus' }
vim.opt.mouse = { a = true }
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true })
vim.keymap.set('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true })

vim.opt.shortmess:remove { 'S' } -- show number of matches

-- fold
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.keymap.set('n', '<ESC>', '<Cmd>nohlsearch<CR>')

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- panes
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('t', '<C-h>', '<C-w>h')
vim.keymap.set('t', '<C-j>', '<C-w>j')
vim.keymap.set('t', '<C-k>', '<C-w>k')
vim.keymap.set('t', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<C-w><C-h>', '<Cmd>vertical resize -2<CR>')
vim.keymap.set('n', '<C-w><C-j>', '<Cmd>resize -2<CR>')
vim.keymap.set('n', '<C-w><C-k>', '<Cmd>resize +2<CR>')
vim.keymap.set('n', '<C-w><C-l>', '<Cmd>vertical resize +2<CR>')

-- others
vim.opt.hidden = true
vim.opt.encoding = 'utf-8'
vim.opt.autoread = true
vim.opt.autowriteall = true
vim.keymap.set('n', '<C-q>', '<Cmd>quit<CR>')

vim.cmd('colorscheme onedark')
