return {
  "Shatur/neovim-ayu",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd('colorscheme ayu')

    -- Custom highlights applied after colorscheme
    vim.cmd([[highlight LineNr guifg=#666666]])
    vim.cmd([[highlight CursorLineNr guifg=#A9A9A9]])
    vim.cmd([[highlight Comment ctermfg=cyan guifg=#ff79c6]])
  end,
}
