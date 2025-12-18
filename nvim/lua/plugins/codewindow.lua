-- Minimap sidebar using treesitter for syntax highlighting
return {
  'gorbit99/codewindow.nvim',
  event = 'VeryLazy',
  config = function()
    local codewindow = require('codewindow')
    codewindow.setup({
      auto_enable = false,
      minimap_width = 15,
      width_multiplier = 4,
      window_border = 'single',
    })
    vim.keymap.set('n', '<leader>mm', codewindow.toggle_minimap, { desc = 'Toggle minimap' })
  end,
}
