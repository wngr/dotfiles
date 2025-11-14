-- Editor options
local opt = vim.opt
local g = vim.g

-- UI
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.colorcolumn = "80"
opt.showmatch = true
opt.matchtime = 2
opt.laststatus = 2  -- Always show statusline

-- Splits
g.splitright = true
g.splitbelow = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- Text formatting
opt.textwidth = 80
opt.wrap = true
opt.formatoptions = "cqj" -- c=auto-wrap comments, q=allow gq, j=remove comment leader when joining
g.joinspaces = false

-- Spell checking
opt.spelllang = "en,de"

-- Files
opt.undofile = true

-- Timing
opt.updatetime = 300

-- Syntax
vim.cmd('syntax enable')

-- Kill only this Neovim's rust-analyzer on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.name == "rust-analyzer" then
        client.stop()
      end
    end
  end,
})
