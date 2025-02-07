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
      require('which-key').register({
        ['d'] = {
          name = 'Debug',
          t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'Toggle Breakpoint' },
          b = { "<cmd>lua require'dap'.step_back()<cr>", 'Step Back' },
          c = { "<cmd>lua require'dap'.continue()<cr>", 'Continue' },
          C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", 'Run To Cursor' },
          d = { "<cmd>lua require'dap'.disconnect()<cr>", 'Disconnect' },
          g = { "<cmd>lua require'dap'.session()<cr>", 'Get Session' },
          i = { "<cmd>lua require'dap'.step_into()<cr>", 'Step Into' },
          o = { "<cmd>lua require'dap'.step_over()<cr>", 'Step Over' },
          u = { "<cmd>lua require'dap'.step_out()<cr>", 'Step Out' },
          p = { "<cmd>lua require'dap'.pause()<cr>", 'Pause' },
          r = { "<cmd>lua require'dap'.repl.toggle()<cr>", 'Toggle Repl' },
          s = { "<cmd>lua require'dap'.continue()<cr>", 'Start' },
          q = { "<cmd>lua require'dap'.close()<cr>", 'Quit' },
          U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", 'Toggle UI' },
          f = { "<cmd>lua require'dapui'.eval()<cr>", 'Toggle floating under cursor' },
        },

        ['b'] = {
          name = 'Buffer',
          N = { '<cmd>enew<cr>', 'New Buffer' },
          n = { '<cmd>bnext<cr>', 'Next Buffer' },
          b = { '<cmd>bprevious<cr>', 'Previous Buffer' },
        },

        ['T'] = { name = 'Toggle', _ = 'which_key_ignore' },
        ['e'] = { 'NeoTree reveal', _ = 'which_key_ignore' },
        ['w'] = { '<cmd>w!<CR>', 'Save' },
        ['c'] = { '<cmd>BufferKill<CR>', 'Close Buffer' },
        ['q'] = { '<cmd>confirm q<CR>', 'Quit' },
        ['/'] = { '<Plug>(comment_toggle_linewise_current)', 'Comment toggle current line' },
      }, {
        prefix = '<leader>',
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
