local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local is_nixos = vim.fn.filereadable('/etc/NIXOS') ~= 0

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
  if not is_nixos then
    use { 'williamboman/mason.nvim' }
    use { 'williamboman/mason-lspconfig.nvim' }
  end
  use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'vhminh/better-telescope-builtins.nvim', requires = 'nvim-telescope/telescope.nvim' }
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  }
  use 'tpope/vim-commentary'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use { 'NTBBloodbath/galaxyline.nvim', requires = 'kyazdani42/nvim-web-devicons' }
  use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
  use {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup {}
    end,
  }
  use {
    'liuchengxu/vista.vim',
    config = function()
      vim.g.vista_default_executive = 'nvim_lsp'
      vim.keymap.set('n', '<leader>t', '<Cmd>Vista!!<CR>')
    end,
  }
  use 'justinmk/vim-sneak'
  use 'onsails/lspkind-nvim'
  use {
    'SmiteshP/nvim-navic',
    config = function()
      local navic = require('nvim-navic')
      navic.setup({
        lsp = {
          auto_attach = true,
        },
        highlight = true,
        safe_output = true,
      })
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
    end,
  }
  use 'folke/neodev.nvim'
  use 'ckipp01/stylua-nvim'
  use 'tpope/vim-sleuth'
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('ibl').setup { indent = { char = '│'} }
    end,
  }
  use { 'scalameta/nvim-metals', requires = { 'nvim-lua/plenary.nvim' } }
end)

if need_install_plugin then
  vim.api.nvim_command 'PackerSync'
end
vim.api.nvim_command 'PackerInstall'

require('plugins.theme')
require('plugins.filetree')
require('plugins.lsp')
require('plugins.fuzzyfinder')
require('plugins.git')
require('plugins.treesitter')
require('plugins.sneak')
require('plugins.statusline')
