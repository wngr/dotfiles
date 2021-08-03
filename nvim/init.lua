require('plugins')

--- helpers
local opt = vim.opt
local o = vim.o
local g = vim.g
local fn = vim.fn
local map = vim.api.nvim_set_keymap

---
--color scheme
vim.opt.termguicolors = true
--o.background = "light"
vim.cmd('colorscheme ayu')
--vim.g.ayu_mirage = true

---- intuitive splits
g.splitright = true
g.splitbelow = true

-- syntax highlighting
o.syntax = 'enable'

-- only one space for joins
g.joinspaces = false

o.updatetime = 300
opt.spelllang = "en,de"
opt.tabstop = 2
opt.showmatch = true
opt.matchtime = 2
opt.shiftwidth = 2
opt.sw = 2
opt.number = true
opt.syntax = "on"

local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

----------------------------
-- rust lsp setup
require'lspinstall'.setup() -- important

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{on_attach=require'completion'.on_attach}
end

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
-- rust-analyzer inlay hints
function inlay_hints()
    require('lsp_extensions').inlay_hints({
        enabled = { "ChainingHint", "ParameterHint", "TypeHint" }
    })
end
vim.cmd('autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua inlay_hints()')

-- key mapping
g.mapleader = ","
local function bmap(a, b, c) vim.api.nvim_buf_set_keymap(bufnr, a, b, c, { noremap = true, silent = true }) end
local function hmap(a, b, c) vim.api.nvim_set_keymap(a, b, c, { noremap = true, silent = true }) end
--bmap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
hmap('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
--hmap('n', '<leader>lt', '<Cmd>lua vim.lsp.buf.definition()<CR>')
--hmap('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
hmap('n', '<leader>la', ':Telescope lsp_code_actions<CR>')
--bmap('n', '<leader>lff', '<Cmd>lua vim.lsp.buf.hover()<CR>')
--bmap('n', '<leader>lfi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
hmap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
hmap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
--hmap('n', '<leader>lx', '<cmd>lua vim.lsp.buf.references()<CR>')
hmap('n', '<leader>lx', ':Telescope lsp_references<CR>')
hmap('n', '<leader>li', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')

hmap('n', '<leader>lo', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
hmap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')

--hmap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
hmap('n', '<leader>ls', ':Telescope lsp_workspace_symbols<CR>')
hmap('n', '<leader>le', ':Telescope lsp_document_diagnostics<CR>')
hmap('n', '<leader>lw', ':Telescope lsp_workspace_diagnostics<CR>')
-- https://github.com/gfanto/fzf-lsp.nvim#commands

    -- List symbols in the current document matching the query string.
    -- nnoremap <silent> <LEADER>l?  <cmd>lua vim.lsp.buf.document_symbol()<CR>
    -- List project-wide symbols matching the query string.
    -- nnoremap <silent> <LEADER>lw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>


map('n', '<C-T>', ':NERDTreeToggle<CR>', { silent = true })
-- search
map('', '<leader>s', ':Telescope live_grep<CR>', { noremap = true })
map('', '<leader>f', ':Telescope find_files<CR>', { noremap = true })

-- go to previous/next buffer
map('n', '<leader>m', ':bnext<CR>', { noremap = true })
map('n', '<leader>n', ':bprev<CR>', { noremap = true })

-- close current buffer
-- move to previous buffer, close the last one (to keep split positions)
map('n', '<leader>d', ':bp|bd #<CR>', { noremap = true })

-- close current buffer
map('n', '<leader><leader>', ':b#<CR>', { noremap = true })

-- buffer search (fzf)
map('', '<leader>b', ':Telescope buffers<CR>', {})


-- navigate windows
map('n', '<C-k>', ':wincmd k<CR>', { silent = true })
map('n', '<C-j>', ':wincmd j<CR>', { silent = true })
map('n', '<C-h>', ':wincmd h<CR>', { silent = true })
map('n', '<C-l>', ':wincmd l<CR>', { silent = true })
----------------------------

-- Use <Tab> and <S-Tab> to navigate through popup menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', '<Plug>(completion_smart_tab)', {})
map('i', '<S-Tab>', '<Plug>(completion_smart_s_tab)', {})

opt.completeopt = "menuone,noinsert,noselect"


-- ===========================================
-- STATUSLINE
-- ===========================================

g.lightline = {
    colorscheme = 'deus',
    active = {
        right = { 
            { 'lsp_errors', 'lsp_warnings', 'lsp_info', 'lsp_ok', 'lineinfo' },
            { 'percent' },
            { 'fileformat', 'fileencoding', 'filetype' }
        }
    },
    tabline = {
        left = { { 'buffers' } },
        right = { { 'close' } },
    },
    component_expand = {
        lsp_info = '{ -> luaeval(\'LspStatus([[Info]], [[I]])\') }',
        lsp_warnings = '{ -> luaeval(\'LspStatus([[Warning]], [[W]])\') }',
        lsp_errors = '{ -> luaeval(\'LspStatus([[Error]], [[E]])\') }',
        lsp_ok = '{ -> luaeval(\'LspOk()\') }',
        buffers = 'lightline#bufferline#buffers'
    },
    component_type = {
        lsp_ok = 'left',
        lsp_info = 'middle',
        lsp_warnings = 'warning',
        lsp_errors = 'error',
        buffers = 'tabsel'
    },
}

g['lightline#bufferline#enable_devicons'] = 1

vim.api.nvim_exec([[
    augroup lightline#lsp
      autocmd!
      autocmd User LspDiagnosticsChanged call lightline#update()
    augroup END
]], false)

function _G.LspStatus(kind, sym)
    if next(vim.lsp.buf_get_clients(0)) == nil then
        return ''
    end
    local count = vim.lsp.diagnostic.get_count(0, kind)
    if count == 0 then 
        return '' 
    else 
        return sym .. ': ' .. count
    end
end

function _G.LspOk()
    if next(vim.lsp.buf_get_clients(0)) == nil then
        return ''
    end
    local h = vim.lsp.diagnostic.get_count(0, 'Hint')
    local w = vim.lsp.diagnostic.get_count(0, 'Warning')
    local e = vim.lsp.diagnostic.get_count(0, 'Error')
    local i = vim.lsp.diagnostic.get_count(0, 'Info')

    if h + w + e + i == 0 then
        return 'OK'
    else
        return ''
    end
end
