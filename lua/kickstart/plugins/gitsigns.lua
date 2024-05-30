-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local wk = require 'which-key'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git change' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git change' })

        -- Actions
        -- visual mode
        map('v', '<leader>Gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>Gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })

        wk.register({
          ['g'] = {
            name = 'Git',
            -- g = { "<cmd>lua require 'terminal'.lazygit_toggle()<cr>", 'Lazygit' },
            l = { gitsigns.blame_line, 'Blame' },
            L = { gitsigns.blame_line { full = true }, 'Blame Line (full)' },
            p = { gitsigns.preview_hunk, 'Preview Hunk' },
            r = { gitsigns.reset_hunk, 'Reset Hunk' },
            R = { gitsigns.reset_buffer, 'Reset Buffer' },
            s = { gitsigns.stage_hunk, 'Stage Hunk' },
            S = { gitsigns.stage_buffer, 'Stage Buffer' },
            u = { gitsigns.undo_stage_hunk, 'Undo Stage Hunk' },
            o = { '<cmd>Telescope git_status<cr>', 'Git status' },
            b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
            c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
            C = {
              '<cmd>Telescope git_bcommits<cr>',
              'Checkout commit(for current file)',
            },
            d = {
              '<cmd>Gitsigns diffthis HEAD<cr>',
              'Git Diff ~HEAD',
            },
            D = { '<cmd>Gitsigns diffthis @<cr>', 'Diff against last commit' },
          },
        }, { prefix = '<leader>' })

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git show blame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = 'Toggle git show Deleted' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
