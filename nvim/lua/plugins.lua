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
  use 'williamboman/nvim-lsp-installer'
-- 	use 'gfanto/fzf-lsp.nvim'
    -- Completion framework
    use 'hrsh7th/nvim-cmp'

    -- LSP completion source for nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp'

    -- Snippet completion source for nvim-cmp
    use 'hrsh7th/cmp-vsnip'

    -- Other usefull completion sources
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'

  -- Rust
--  use 'simrat39/rust-tools.nvim'
--  use 'nvim-lua/popup.nvim'
--  use 'nvim-lua/plenary.nvim'
--
-- color theme
  use 'Shatur/neovim-ayu'
end)
