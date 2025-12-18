-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Set LSP log level
-- vim.lsp.set_log_level("debug")

-- Global state for LSP progress tracking
_G.lsp_progress = {}

-- Configure rustaceanvim BEFORE lazy.nvim loads it
vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5f6661" })
    end,
    on_init = function(client, result)
      vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
    end,
    handlers = {
      ["$/progress"] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then return end

        local token = result.token
        local value = result.value

        if not _G.lsp_progress[client.name] then
          _G.lsp_progress[client.name] = {}
        end

        if value.kind == "begin" then
          _G.lsp_progress[client.name][token] = {
            title = value.title,
            message = value.message,
            percentage = value.percentage,
          }
        elseif value.kind == "report" then
          if _G.lsp_progress[client.name][token] then
            _G.lsp_progress[client.name][token].message = value.message
            _G.lsp_progress[client.name][token].percentage = value.percentage
          end
        elseif value.kind == "end" then
          _G.lsp_progress[client.name][token] = nil
        end

        -- Trigger statusline refresh
        vim.cmd('redrawstatus')
      end,
    },
    default_settings = {
      ['rust-analyzer'] = {
        checkOnSave = true,
         check = {
           --command = "clippy",
         },
        files = {
          excludeDirs = { '.worktrees', '.direnv', "frontend", ".pnpm-store", "hs-data-systems-brb-ui" },
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
          extraEnv = { CARGO_PROFILE_RUST_ANALYZER_INHERITS = 'dev', },
          extraArgs = { "--profile", "rust-analyzer", },
          features = "all",
        },
--        diagnostics = {
--          enable = true,
--          experimental = {
--            enable = true,
--          },
--        },
        -- Uncomment these if rust-analyzer is too slow:
        -- checkOnSave = {
        --   command = "check", -- Use 'check' instead of 'clippy' for speed
        -- },
         procMacro = {
           enable = true,
         },
      },
    },
    capabilities = {
      completion = {
        completionItem = {
          snippetSupport = false,
        },
      },
    },
  },
  dap = {},
}

-- Load configuration
require("config.options")
require("config.keymaps")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "ayu" } },
  checker = { enabled = false }, -- Don't auto-check for updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
