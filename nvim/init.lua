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

vim.wo.relativenumber = true

require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
-- override = {
--  zsh = {
--    icon = "",
--    color = "#428850",
--    cterm_color = "65",
--    name = "Zsh"
--  }
-- };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}
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
o.textwidth = 80
opt.textwidth = 80
opt.wrap = true
opt.spelllang = "en,de"
opt.tabstop = 2
opt.expandtab = true
opt.showmatch = true
opt.matchtime = 2
opt.shiftwidth = 2
opt.sw = 2
opt.number = true
opt.syntax = "on"
opt.undofile = true
o.colorcolumn = "80"
o.formatoptions = "cqj" -- t == autoformat
opt.cursorline = true

vim.cmd [[highlight LineNr guifg=#666666]]
vim.cmd [[highlight CursorLineNr guifg=#A9A9A9]]
vim.cmd [[highlight Comment ctermfg=cyan guifg=#ff79c6]]




-- setup mason first
--require("mason").setup()
--require("mason-lspconfig").setup()

--lspconfig = require('lspconfig')

--require("mason-lspconfig").setup_handlers {
--    -- The first entry (without a key) will be the default handler
--    -- and will be called for each installed server that doesn't have
--    -- a dedicated handler.
--    function (server_name) -- default handler (optional)
--        lspconfig[server_name].setup {}
--    end,
--   ["tsserver"] = function()
--     lspconfig.tsserver.setup({
--       settings = {
--           typescript = {
--           format = {
--             convertTabsToSpaces = true,
--             indentSize = 4,
--             indentStyle = "Smart",
--             tabSize = 4,
--             trimTrailingWhitespace = true,
--           }
--         }
--       }
--     })
--   end,
--
--    -- Next, you can provide a dedicated handler for specific servers.
--    -- For example, a handler override for the `rust_analyzer`:
----   ["rust_analyzer"] = function ()
----      local opts = {
----        tools = { -- rust-tools options
----          autoSetHints = true,
----          hover_with_actions = true,
----          inlay_hints = {
----            auto = true,
----            show_parameter_hints = true,
----            parameter_hints_prefix = "<- ",
----            other_hints_prefix = "=> ",
----            },
----        },
----
----      -- all the opts to send to nvim-lspconfig
----      -- these override the defaults set by rust-tools.nvim
----      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
----        server = {
----          -- on_attach is a callback called when the language server attachs to the buffer
----          -- on_attach = on_attach,
----          settings = {
----            -- to enable rust-analyzer settings visit:
----            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
----            ["rust-analyzer"] = {
----              imports = {
----                granularity = {
----                  group = "crate",
----                },
----                group = {
----                  enable = false,
----                },
----              },
---- --             diagnostics = {
---- --               enable = true,
---- --               disabled = {"unresolved-proc-macro"},
---- --               enableExperimental = true,
---- --             },
----              -- enable clippy on save
------              checkOnSave = true,
----              check = {
----                command = "clippy",
----                --overrideCommand = { "cargo", "clippy", "--message-format=json", "--manifest-path=client/js/Cargo.toml" }, -- wasm
----      --          invocationStrategy = "once",
----                --invocationLocation = "root",
----              },
------              procMacro = { -- enabled by default now
------                enable = true,
------              },
----              cargo = {
----                --noDefaultFeatures = "XXXXX",
----               features = "all",
------                target = "wasm32-unknown-unknown", -- wasm
----     --           buildScripts = {
----     --             enable = true,
------                  overrideCommand = { "cargo", "check", "--quiet", "--message-format=json" }, -- wasm
----      --            invocationStrategy = "once",
----      --            invocationLocation = "root",
----    --            }
----              },
----            }
----          }
----        },
----      }
----
----      require('rust-tools').setup(opts)
----   end
--}

-- trouble setup
require'nvim-web-devicons'.setup {}
require'trouble'.setup{
  modes = {
    diagnostics_custom = {
      mode = "diagnostics",
      preview = {
        type = "split",
        relative = "win",
        position = "right",
        size = 0.3,
      },
      filter = {
        any = {
          buf = 0, -- current buffer
          {
            severity = vim.diagnostic.severity.ERROR, -- errors only
            -- limit to files in the current project
            function(item)
              return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
            end,
          },
        },
      },
    },
  },
}


--local ts = require 'nvim-treesitter.configs'
--ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

----------------------------
--local lsp_installer_servers = require'nvim-lsp-installer.servers'
--
--local ok, rust_analyzer = lsp_installer_servers.get_server("rust_analyzer")
--if ok then
--    if not rust_analyzer:is_installed() then
--        rust_analyzer:install()
--    end
--end


-- local lsp_installer = require("nvim-lsp-installer")
-- 
-- lsp_installer.on_server_ready(function(server)
--     -- (optional) Customize the options passed to the server
--     if server.name == "rust_analyzer" then
-- 
--       require('rust-tools').setup({})
-- --      server:setup(
-- --      {
-- --        settings = {
-- --          ["rust-analyzer"] = {
-- --            assist = {
-- --              importGranularity = "crate",
-- --              importPrefix = "by_crate",
-- --              allowMergingIntoGlobImports = false
-- --            },
-- --      --      diagnostics = {
-- --      --        disabled = { "unresolved-import" }
-- --      --      },
-- ----            cargo = {
-- ----                loadOutDirsFromCheck = true,
-- ----                allFeatures = true
-- ----            },
-- --            procMacro = {
-- --                enable = true
-- --            },
-- --            checkOnSave = {
-- --                command = "clippy"
-- --            },
-- --          }
-- --        }
-- --      }
-- --      )
--     end
-- end)
-- 
-- 
-- 
-- -- Enable diagnostics
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--   vim.lsp.diagnostic.on_publish_diagnostics, {
--     virtual_text = true,
--     signs = true,
--     update_in_insert = true,
--   }
-- )
-- -- rust-analyzer inlay hints
-- function inlay_hints()
--     require('lsp_extensions').inlay_hints({
--         enabled = { "ChainingHint", "ParameterHint", "TypeHint" }
--     })
-- end
-- vim.cmd('autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua inlay_hints()')

-- key mapping
g.mapleader = ","
local function bmap(a, b, c) vim.api.nvim_buf_set_keymap(bufnr, a, b, c, { noremap = true, silent = true }) end
local function hmap(a, b, c) vim.api.nvim_set_keymap(a, b, c, { noremap = true, silent = true }) end
--bmap('n', '<leader>ld', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
--hmap('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
hmap('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>')
--hmap('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
hmap('n', '<leader>la', '<Cmd>lua vim.cmd.RustLsp("codeAction")<CR>')
--hmap('n', '<leader>la', ':RustHoverActions<CR>')
hmap('n', '<leader>le', ':Trouble diagnostics_custom toggle<CR>')
--hmap('n', '<leader>la', ':Telescope vim.lsp.buf.code_action()<CR>')
--bmap('n', '<leader>lff', '<Cmd>lua vim.lsp.buf.hover()<CR>')
--bmap('n', '<leader>lfi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
hmap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
hmap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
--hmap('n', '<leader>lx', '<cmd>lua vim.lsp.buf.references()<CR>')
hmap('n', '<leader>lx', ':Telescope lsp_references<CR>')
hmap('n', '<leader>li', '<cmd>lua vim.diagnostic.goto_prev()<CR>')

hmap('n', '<leader>lo', '<cmd>lua vim.diagnostic.goto_next()<CR>')
hmap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.format { async = true }<CR>')

--hmap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
hmap('n', '<leader>ls', ':Telescope lsp_dynamic_workspace_symbols<CR>')
hmap('n', '<leader>lw', ':Telescope lsp_document_symbols<CR>')
--hmap('n', '<leader>le', ':Telescope lsp_document_diagnostics<CR>')
hmap('n', '<leader>lq', ':Telescope lsp_workspace_diagnostics<CR>')
-- https://github.com/gfanto/fzf-lsp.nvim#commands

    -- List symbols in the current document matching the query string.
    -- nnoremap <silent> <LEADER>l?  <cmd>lua vim.lsp.buf.document_symbol()<CR>
    -- List project-wide symbols matching the query string.
    -- nnoremap <silent> <LEADER>lw  <cmd>lua vim.lsp.buf.workspace_symbol()<CR>


map('n', '<C-T>', ':NERDTreeFind<CR>', { silent = true })
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
-- 
-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
-- Completion behavior
---vim.opt.completeopt = { 'menuone' ,'noinsert', 'noselect' }
---vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
--  snippet = {
--    expand = function(args)
--        vim.fn["vsnip#anonymous"](args.body)
--    end,
--  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp', priority = 1000, },
    { name = 'nvim_lsp_signature_help' },
--    { name = 'vsnip', priority = 900, },
--    { name = 'path', priority = 800, },
--    { name = 'buffer', priority = 700, },
  },
})

require('cmp_nvim_lsp')

require("todo-comments").setup(
{
  highlight = {
    pattern = { [[.*<(KEYWORDS).*:]], [[.*\@(KEYWORDS).*]] },
  },
  search = {
    pattern = [[\b(KEYWORDS)\b]],
  },
}
)


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
    local count = vim.diagnostic.get(0, kind)
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
    local h = vim.diagnostic.get(0, { severity = 'Hint'})
    local w = vim.diagnostic.get(0, { severity = 'Warning'})
    local e = vim.diagnostic.get(0, { severity = 'Error'})
    local i = vim.diagnostic.get(0, { severity = 'Info'})

    if h + w + e + i == 0 then
        return 'OK'
    else
        return ''
    end
end


-- TODO
local lsp_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
end

--- rustacieanvim
local rust_lsp_on_attach = function(client, bufnr)
  lsp_on_attach(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

--  buf_set_keymap('n', '<space>k', "<cmd>lua vim.cmd.RustLsp('openDocs')<CR>", opts)
--  buf_set_keymap('n', '<space>p', "<cmd>lua vim.cmd.RustLsp('openCargo')<CR>", opts)
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5f6661" })
--    if client.server_capabilities.inlayHintProvider then
--      buf_set_keymap('n', '<leader>h', function()
--        local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
--        vim.lsp.inlay_hint.enable(bufnr, not current_setting)
--      end, opts)
--    end
end


vim.g.rustaceanvim = function()
  return {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
      on_attach = rust_lsp_on_attach,
      default_settings = {
        -- rust-analyzer language server configuration
        ['rust-analyzer'] = {
          checkOnSave = true,
          files = {
            excludeDirs = {'.worktrees', '.direnv' },
            --            watcher = "server",
          },
          cargo = {
              extraEnv = { CARGO_PROFILE_RUST_ANALYZER_INHERITS = 'dev', },
              extraArgs = { "--profile", "rust-analyzer", },
              features = "all",
          },
        },
      },
      capabilities = {
       completion = {
          completionItem = {
            snippetSupport = false,
          },
        }
      }
    },
    -- DAP configuration
    dap = {
    },
  }
end

-- neovim + ra workaround
-- https://github.com/neovim/neovim/issues/30985#issuecomment-2447329525
--for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
--    local default_diagnostic_handler = vim.lsp.handlers[method]
--    vim.lsp.handlers[method] = function(err, result, context, config)
--        if err ~= nil and err.code == -32802 then
--            return
--        end
--        return default_diagnostic_handler(err, result, context, config)
--    end
--end
--

