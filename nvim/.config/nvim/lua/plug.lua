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
  use 'tpope/vim-sleuth'
  use { 'scalameta/nvim-metals', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvimdev/lspsaga.nvim',
    -- after = { 'neovim/nvim-lspconfig' },
    opt = true,
    event = 'LspAttach',
    config = function()
      require('lspsaga').setup({})
    end,
    requires = { 'neovim/nvim-lspconfig', 'nvim-tree/nvim-web-devicons', 'nvim-treesitter/nvim-treesitter', } }
end)

if need_install_plugin then
  vim.api.nvim_command 'PackerSync'
end
vim.api.nvim_command 'PackerInstall'

require('plugins.theme')
require('plugins.filetree')
require('plugins.lsp')
require('plugins.fuzzyfinder')
require('plugins.autopairs')
require('plugins.git')
require('plugins.treesitter')
require('plugins.sneak')
require('plugins.statusline')
require('plugins.tags')
