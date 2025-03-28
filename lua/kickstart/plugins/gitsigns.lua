-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- signs = {
      --   add = { text = '+' },
      --   change = { text = '~' },
      --   delete = { text = '_' },
      --   topdelete = { text = '‾' },
      --   changedelete = { text = '~' },
      -- },
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

        wk.add {
          { '<leader>g', group = 'Git' },
          { '<leader>gl', gitsigns.blame_line, desc = 'Blame' },
          {
            '<leader>gL',
            function()
              gitsigns.blame_line { full = true }
            end,
            desc = 'Blame Line (full)',
          },
          { '<leader>gp', gitsigns.preview_hunk, desc = 'Preview Hunk' },
          { '<leader>gr', gitsigns.reset_hunk, desc = 'Reset Hunk' },
          { '<leader>gR', gitsigns.reset_buffer, desc = 'Reset Buffer' },
          { '<leader>gs', gitsigns.stage_hunk, desc = 'Stage Hunk' },
          { '<leader>gS', gitsigns.stage_buffer, desc = 'Stage Buffer' },
          { '<leader>gu', gitsigns.undo_stage_hunk, desc = 'Undo Stage Hunk' },
          { '<leader>go', '<cmd>Telescope git_status<cr>', desc = 'Git status' },
          { '<leader>gb', '<cmd>Telescope git_branches<cr>', desc = 'Checkout branch' },
          { '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'Checkout commit' },
          { '<leader>gC', '<cmd>Telescope git_bcommits<cr>', desc = 'Checkout commit(for current file)' },
          { '<leader>gd', '<cmd>Gitsigns diffthis HEAD<cr>', desc = 'Git Diff ~HEAD' },
          { '<leader>gD', '<cmd>Gitsigns diffthis @<cr>', desc = 'Diff against last commit' },
        }

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git show blame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = 'Toggle git show Deleted' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
