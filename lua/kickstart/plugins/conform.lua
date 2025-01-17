return {
  { -- formatting
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>lf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = 'Format buffer',
      },
      {
        '<leader>lF',
        '<cmd>EslintFixAll<cr>',
        desc = 'Format buffer with eslint',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { 'eslint', 'prettierd' },
        typescript = { 'eslint', 'prettierd' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
