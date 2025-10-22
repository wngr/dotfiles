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
vim.lsp.set_log_level("debug")

-- Configure rustaceanvim BEFORE lazy.nvim loads it
vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5f6661" })
    end,
    on_init = function(client, result)
      print("rust-analyzer initialized")
      print("Root dir: " .. (client.config.root_dir or "none"))

      -- After indexing, request workspace diagnostics to check if RA has data
      vim.defer_fn(function()
        local params = { textDocument = vim.lsp.util.make_text_document_params() }
        client.request("textDocument/documentSymbol", params, function(err, symbols)
          if err then
            print("Document symbols error:", vim.inspect(err))
          elseif not symbols or #symbols == 0 then
            print("WARNING: No symbols found - rust-analyzer has no semantic data!")
          else
            print("Found " .. #symbols .. " symbols - rust-analyzer working!")
          end
        end)
      end, 8000)
    end,
    handlers = {
      ["$/progress"] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if result.value and result.value.message then
          print(string.format("[%s] %s", client.name, result.value.message))
        end
        -- Notify when a task completes
        if result.value and result.value.kind == "end" then
          print(string.format("[%s] Task completed: %s", client.name, result.token))
        end
      end,
    },
    default_settings = {
      ['rust-analyzer'] = {
        checkOnSave = true,
         check = {
           command = "clippy",
         },
        files = {
          excludeDirs = { '.worktrees', '.direnv' },
        },
        cargo = {
          buildScripts = {
            enable = true,
          },
        },
        procMacro = {
          enable = true,
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
           enable = false, -- Disable proc macro expansion if slow
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
