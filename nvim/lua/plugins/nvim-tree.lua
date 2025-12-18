-- ABOUTME: File browser plugin configuration
-- ABOUTME: Provides tree-style file explorer on the left side

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    })

    -- Toggle with Ctrl-t
    vim.keymap.set("n", "<C-t>", "<cmd>NvimTreeFindFileToggle<cr>", { desc = "Toggle file tree" })
  end,
}
