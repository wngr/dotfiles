-- ABOUTME: Statusline configuration with LSP server status display
-- ABOUTME: Shows current mode, file info, diagnostics, and active LSP servers

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'ayu',
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {
          {
            'filename',
            path = 1,  -- 0 = just filename, 1 = relative path, 2 = absolute path
          }
        },
        lualine_x = {
          {
            'diagnostics',
            sources = {'nvim_lsp'},
            sections = {'error', 'warn', 'info', 'hint'},
          },
          {
            -- LSP server status with progress
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if #buf_clients == 0 then
                return ''
              end

              local status_parts = {}
              for _, client in ipairs(buf_clients) do
                local progress = _G.lsp_progress[client.name]
                if progress and next(progress) then
                  -- Get the first active progress item
                  local _, task = next(progress)
                  local msg = task.message or task.title or ''
                  local pct = task.percentage and string.format(' %d%%', task.percentage) or ''
                  table.insert(status_parts, string.format('%s: %s%s', client.name, msg, pct))
                else
                  table.insert(status_parts, client.name)
                end
              end

              return '  ' .. table.concat(status_parts, ' | ')
            end,
            color = { fg = '#59c2ff' },  -- ayu blue
          },
          'filetype',
        },
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            path = 1,
          }
        },
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
    })
  end,
}
