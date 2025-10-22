-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LSP keymaps (defined globally, will work when LSP attaches)
map('n', '<leader>ld', vim.lsp.buf.definition, opts)
map('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
map('n', '<leader>lr', vim.lsp.buf.rename, opts)
map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, opts)
map('n', '<leader>li', vim.diagnostic.goto_prev, opts)
map('n', '<leader>lo', vim.diagnostic.goto_next, opts)

-- Rust-specific LSP (via rustaceanvim)
map('n', '<leader>la', function() vim.cmd.RustLsp('codeAction') end, opts)
map('n', '<leader>lL', function() vim.cmd.RustLsp('logFile') end, opts) -- View rust-analyzer logs

-- Telescope keymaps
map('n', '<leader>s', ':Telescope live_grep<CR>', opts)
map('n', '<leader>f', ':Telescope find_files<CR>', opts)
map('n', '<leader>b', ':Telescope buffers<CR>', opts)
map('n', '<leader>lx', ':Telescope lsp_references<CR>', opts)
map('n', '<leader>ls', ':Telescope lsp_dynamic_workspace_symbols<CR>', opts)
map('n', '<leader>lw', ':Telescope lsp_document_symbols<CR>', opts)

-- Trouble keymaps
map('n', '<leader>le', ':Trouble diagnostics_custom toggle<CR>', opts)

-- Buffer management
map('n', '<leader>m', ':bnext<CR>', opts)
map('n', '<leader>n', ':bprev<CR>', opts)
map('n', '<leader>d', ':bp|bd #<CR>', opts) -- Close buffer, keep split
map('n', '<leader><leader>', ':b#<CR>', opts) -- Toggle to last buffer

-- Window navigation
map('n', '<C-k>', ':wincmd k<CR>', opts)
map('n', '<C-j>', ':wincmd j<CR>', opts)
map('n', '<C-h>', ':wincmd h<CR>', opts)
map('n', '<C-l>', ':wincmd l<CR>', opts)

-- File explorer (netrw)
map('n', '<C-T>', ':Explore<CR>', opts)
