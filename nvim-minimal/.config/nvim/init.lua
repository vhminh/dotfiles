local nnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = false })
end
local nvim_cmd = vim.api.nvim_command

vim.g.mapleader = ' '


-- Packer
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local need_install_plugin = false
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  need_install_plugin = true
  print('Cloning packer.nvim')
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path })
  print('Packadd packer.nvim')
  nvim_cmd('packadd packer.nvim')
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
  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip', 'rafamadriz/friendly-snippets' } }
  use { 'williamboman/nvim-lsp-installer' }
  use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-commentary'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'NTBBloodbath/galaxyline.nvim', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
  use 'justinmk/vim-sneak'
  use 'liuchengxu/vista.vim'
  use 'onsails/lspkind-nvim'
  use 'folke/lua-dev.nvim'
  use 'editorconfig/editorconfig-vim'
  use { 'scalameta/nvim-metals', requires = { 'nvim-lua/plenary.nvim' } }
end)

if need_install_plugin then
  nvim_cmd('PackerSync')
end
nvim_cmd('PackerInstall')


-- Colors
-- use onedark color and override gui values with corresponding cterm ones
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
augroup colorextend
autocmd!
let colors = onedark#GetColors()
autocmd ColorScheme * call onedark#extend_highlight('Keyword', { 'fg': colors.purple })
augroup END
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


-- Nvim tree
require('nvim-tree').setup {
  diagnostics = {
    enable = true,
  },
}
nnoremap('<leader>e', '<Cmd>NvimTreeToggle<CR>')


-- Lsp
local lspkind = require('lspkind')
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.completion_trigger_on_delete = true
local cmp = require('cmp')
cmp.setup {
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
    }),
  },
}

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>le', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>lq', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap('n', '<leader>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap('n', '<leader>lf', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  if client.resolved_capabilities.document_highlight then
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

end

-- Nvim lsp installer
local servers = { 'sumneko_lua', 'gopls', 'clangd', 'pyright' }
require('nvim-lsp-installer').setup {
  ensure_installed = servers,
}

-- setup language server options
for _, server in pairs(servers) do
  local opt = {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
  if server == 'sumneko_lua' then
    opt = require('lua-dev').setup { lspconfig = opt }
  end
  require('lspconfig')[server].setup(opt)
end


-- Metals
local metals_config = require('metals').bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { 'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl' },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
metals_config.capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
metals_config.on_attach = on_attach
local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'scala', 'sbt' },
  callback = function()
    require('metals').initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})


-- Vsnip
vim.api.nvim_set_keymap('i', '<Tab>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"', { expr = true, noremap = false })
vim.api.nvim_set_keymap('s', '<Tab>', 'vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<Tab>"', { expr = true, noremap = false })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"', { expr = true, noremap = false })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"', { expr = true, noremap = false })


-- Telescope
local telescope = require('telescope')
telescope.setup {
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
    } or nil,
  },
}

telescope.load_extension('fzf')

nnoremap('<C-f>', '<Cmd>lua require("telescope.builtin").find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!{.git,node_modules}"} })<CR>')
nnoremap('<leader>f', '<Cmd>lua require("telescope.builtin").find_files({ find_command = {"rg", "--files", "--hidden", "-g", "!{.git,node_modules}"} })<CR>')
nnoremap('<leader>b', '<Cmd>lua require("telescope.builtin").buffers()<CR>')
nnoremap('<leader>g', '<Cmd>lua require("telescope.builtin").live_grep()<CR>')
nnoremap('gr', '<Cmd>lua require("telescope.builtin").lsp_references()<CR>')
nnoremap('<leader>ca', '<Cmd>lua require("telescope.builtin").lsp_code_actions()<CR>')
nnoremap('<leader>s', '<Cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>')
nnoremap('<leader>d', '<Cmd>lua require("telescope.builtin").diagnostics()<CR>')
nnoremap('gi', '<Cmd>lua require("telescope.builtin").lsp_implementations()<CR>')
nnoremap('<leader>a', '<Cmd>lua require("telescope.builtin").builtin()<CR>')


-- Nvim autopairs
require('nvim-autopairs').setup {}


-- Git signs
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
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<Cmd>lua require(\"gitsigns.actions\").next_hunk()<CR>'" },
    ['n [c'] = { expr = true, "&diff ? '[c' : '<Cmd>lua require(\"gitsigns.actions\").prev_hunk()<CR>'" },
    ['n <leader>hs'] = '<Cmd>lua require("gitsigns").stage_hunk()<CR>',
    ['v <leader>hs'] = '<Cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hu'] = '<Cmd>lua require("gitsigns").undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<Cmd>lua require("gitsigns").reset_hunk()<CR>',
    ['v <leader>hr'] = '<Cmd>lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hR'] = '<Cmd>lua require("gitsigns").reset_buffer()<CR>',
    ['n <leader>hp'] = '<Cmd>lua require("gitsigns").preview_hunk()<CR>',
    ['n <leader>hb'] = '<Cmd>lua require("gitsigns").blame_line(true)<CR>',
  },
}


-- Treesitter
vim.cmd('autocmd ColorScheme * highlight TSTypeBuiltin guifg=' .. colors.purple)
vim.cmd('autocmd ColorScheme * highlight TSFuncBuiltin guifg=' .. colors.cyan)
vim.cmd('autocmd ColorScheme * highlight TSPackageName guifg=' .. colors.white)
require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = {
    enable = true,
    custom_captures = {
      ['package.name'] = 'TSPackageName',
    },
  },
}


-- Sneak
vim.g['sneak#label'] = true
vim.g['sneak#prompt'] = ' '
nnoremap('f', '<Plug>Sneak_f')
nnoremap('F', '<Plug>Sneak_F')
nnoremap('t', '<Plug>Sneak_t')
nnoremap('T', '<Plug>Sneak_T')

vim.cmd([[
augroup sneak_highlight
autocmd!
autocmd ColorScheme * highlight Sneak guifg=]] .. colors.background .. ' guibg=' .. colors.yellow .. [[

autocmd ColorScheme * highlight SneakLabel guifg=]] .. colors.background .. ' guibg=' .. colors.yellow .. [[

augroup END
]])


-- Galaxy line
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
      nvim_cmd('hi GalaxyViMode guifg=' .. colors.background .. ' guibg=' .. get_mode_color(mode))
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
    provider = function()
      local fn_name = vim.api.nvim_eval('get(b:, "vista_nearest_method_or_function", "")')
      if fn_name == '' then
        return ''
      end
      return ': ' .. fn_name
    end,
    separator = ' ',
    separator_highlight = { 'NONE', colors.grey },
    highlight = { colors.foreground, colors.grey },
  },
}
gls.left[6] = { DiagnosticError = { provider = 'DiagnosticError', icon = '  ', highlight = { colors.red, colors.grey } } }
gls.left[7] = { DiagnosticWarn = { provider = 'DiagnosticWarn', icon = '  ', highlight = { colors.yellow, colors.grey } } }
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


-- Vista
vim.g.vista_default_executive = 'nvim_lsp'
nnoremap('<leader>t', '<Cmd>Vista!!<CR>')


-- Other
vim.api.nvim_set_keymap('', '<C-c>', '<ESC>', { noremap = false })
vim.api.nvim_set_keymap('i', '<C-c>', '<ESC>', { noremap = false })

local opt = vim.opt
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.listchars = { tab = '» ', trail = '~', }
opt.list = true
opt.fillchars = { vert = '|', }
opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.scrolloff = 5
opt.wrap = false
opt.showmatch = true
opt.showcmd = true
opt.showmode = false
opt.backspace = { 'indent', 'eol', 'start' }
opt.clipboard = { 'unnamedplus' }
opt.mouse = { a = true }

opt.shortmess:remove { 'S', 'F' }

opt.foldmethod = 'indent'
opt.foldlevelstart = 99

opt.splitbelow = true
opt.splitright = true

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hidden = true
opt.encoding = 'utf-8'
opt.termguicolors = true
opt.autoread = true
opt.autowriteall = true

vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = false })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = false })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = false })

vim.api.nvim_set_keymap('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, noremap = true })
vim.api.nvim_set_keymap('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, noremap = true })

nnoremap('<ESC>', '<Cmd>nohlsearch<CR>')

nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')

nnoremap('<C-w><C-h>', '<Cmd>vertical resize -2<CR>')
nnoremap('<C-w><C-j>', '<Cmd>resize -2<CR>')
nnoremap('<C-w><C-k>', '<Cmd>resize +2<CR>')
nnoremap('<C-w><C-l>', '<Cmd>vertical resize +2<CR>')

nnoremap('<C-q>', '<Cmd>quit<CR>')

vim.cmd('colorscheme onedark')
