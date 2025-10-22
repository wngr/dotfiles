return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telescope').setup({
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            preview_width = 0.55,
          },
        },
      },
    })
  end,
}
