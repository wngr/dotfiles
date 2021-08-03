return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

	-- ui
	-- Blazing fast pure lua statusline
	use 'itchyny/lightline.vim'
	use 'mengelbrecht/lightline-bufferline'
	-- a command-line fuzzy finder.
--	use 'junegunn/fzf'
--	use 'junegunn/fzf.vim'

  -- generic
  use 'nvim-telescope/telescope.nvim'
	use 'nvim-lua/plenary.nvim' -- needed for telescope
	use 'nvim-lua/popup.nvim' -- needed for telescope
	use 'nvim-treesitter/nvim-treesitter'
	use 'preservim/nerdtree'

	-- lsp
  use 'neovim/nvim-lspconfig'
	use 'nvim-lua/lsp_extensions.nvim'
	use 'nvim-lua/completion-nvim'
  use 'kabouzeid/nvim-lspinstall'
-- 	use 'gfanto/fzf-lsp.nvim'

	-- random
	use 'cespare/vim-toml'

  -- Rust
--  use 'simrat39/rust-tools.nvim'
--  use 'nvim-lua/popup.nvim'
--  use 'nvim-lua/plenary.nvim'
--
-- color theme
  use 'Shatur/neovim-ayu'
end)
