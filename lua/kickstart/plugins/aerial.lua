return {
  {
    'stevearc/aerial.nvim',
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local aerial = require 'aerial'
      local wk = require 'which-key'

      aerial.setup {
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,

        attach_mode = 'global',
        nerd_font = vim.g.have_nerd_font,
      }

      wk.register({
        ['b'] = {
          a = { '<cmd>AerialToggle!<cr>', 'Aerial' },
        },
      }, {
        prefix = '<leader>',
      })
    end,
  },
}
