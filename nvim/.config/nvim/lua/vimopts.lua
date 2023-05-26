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
