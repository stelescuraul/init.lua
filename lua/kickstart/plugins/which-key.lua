local icons = require 'icons'
-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup {
        plugins = {
          presets = {
            operators = false, -- adds help for operators like d, y, ...
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = false, -- default bindings on <c-w>
            nav = false, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = false, -- bindings for prefixed with g
          },
        },
        icons = {
          breadcrumb = icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
          separator = icons.ui.BoldArrowRight, -- symbol used between a key and it's label
          group = icons.ui.Plus, -- symbol prepended to a group
        },
      }

      -- Document existing key chains
      require('which-key').add({
        { '<leader>/', '<Plug>(comment_toggle_linewise_current)', desc = 'Comment toggle current line' },

        { '<leader>T', group = 'Toggle' },
        { '<leader>T_', hidden = true },

        { '<leader>b', group = 'Buffer' },
        { '<leader>bN', '<cmd>enew<cr>', desc = 'New Buffer' },
        { '<leader>bb', '<cmd>bprevious<cr>', desc = 'Previous Buffer' },
        { '<leader>bn', '<cmd>bnext<cr>', desc = 'Next Buffer' },

        { '<leader>e', desc = 'NeoTree reveal' },
        { '<leader>e_', hidden = true },
        { '<leader>q', '<cmd>confirm q<CR>', desc = 'Quit' },
        { '<leader>w', '<cmd>w!<CR>', desc = 'Save' },
        { '<leader>c', '<cmd>BufferKill<CR>', desc = 'Close Buffer' },
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
