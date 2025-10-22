return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('trouble').setup({
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
    })
  end,
}
