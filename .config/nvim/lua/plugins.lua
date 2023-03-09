return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'rstacruz/vim-closer'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use { 'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
  use 'lukas-reineke/headlines.nvim'
  use 'brenoprata10/nvim-highlight-colors'
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = { { 'nvim-lua/plenary.nvim' } } }

  -- Colorschemes
  use 'Mofiqul/vscode.nvim'
  use 'rebelot/kanagawa.nvim'
  use 'phha/zenburn.nvim'
  use 'kvrohit/rasmus.nvim'
  use 'kvrohit/substrata.nvim'
  use 'rmehri01/onenord.nvim'
  use 'kyazdani42/blue-moon'
  use 'navarasu/onedark.nvim'
end)

