return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = { 'rust', 'toml', 'lua', 'vim', 'markdown' },
      auto_install = false, -- Disable to prevent compilation issues
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
