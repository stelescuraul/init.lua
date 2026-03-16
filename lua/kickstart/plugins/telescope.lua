-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

local utils = require 'kickstart.utils'

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    -- event = 'VimEnter',
    -- branch = '0.1.x',
    -- branch = 'master',
    version = '*',
    cond = function()
      return not vim.g.vscode
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local transform_mod = require('telescope.actions.mt').transform_mod
      local actions = require 'telescope.actions'
      local telescope = require 'telescope'

      local window_picker = transform_mod {
        select = function(prompt_bufnr)
          local action_state = require 'telescope.actions.state'
          local picker = action_state.get_current_picker(prompt_bufnr)
          picker.original_win_id = require('window-picker').pick_window()
        end,
      }

      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      require('telescope').setup {
        defaults = {
          mappings = {
            -- for input mode
            i = {
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
              ['<C-h>'] = 'which_key',
              ['<C-o>'] = window_picker.select + actions.select_default,
            },
            -- for normal mode
            n = {
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
              ['<C-o>'] = window_picker.select + actions.select_default,
            },
          },
          layout_config = {
            -- prompt_position = "top",
            height = 0.7,
            width = 0.7,
            bottom_pane = {
              height = 25,
              preview_cutoff = 120,
            },
            center = {
              height = 0.4,
              preview_cutoff = 40,
              width = 0.5,
            },
            cursor = {
              preview_cutoff = 40,
            },
            horizontal = {
              preview_cutoff = 120,
              preview_width = 0.6,
            },
            vertical = {
              preview_cutoff = 40,
            },
            flex = {
              flip_columns = 150,
            },
          },
          layout_strategy = 'flex',
          path_display = {
            filename_first = {
              reverse_directories = false,
            },
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        pickers = {
          buffers = {
            initial_mode = 'normal',
            mappings = {
              n = {
                ['dd'] = function(buffnr)
                  actions.delete_buffer(buffnr)
                end,
              },
            },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'

      -- load our local extension file:
      telescope.load_extension 'qf_replace'

      local wk = require 'which-key'
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      -- keymaps
      utils.map('<leader>sr', function()
        telescope.extensions.qf_replace.qf_replace { mode = 'buffer' }
      end, 'Search/Replace (buffer)')

      utils.map('<leader>sR', function()
        telescope.extensions.qf_replace.qf_replace { mode = 'files' }
      end, 'Search/Replace (files)')

      wk.add {
        { '<leader>bf', builtin.find_files, desc = 'Find Buffers' },
        {
          '<leader>f',
          function()
            builtin.find_files { find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' } }
          end,
          desc = 'Search files',
        },

        { '<leader>s', group = 'Search' },
        { '<leader>s.', builtin.oldfiles, desc = 'Search Recent Files' },
        { '<leader>sF', builtin.current_buffer_fuzzy_find, desc = 'Fuzzy find in buffer' },
        {
          '<leader>sc',
          function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
          end,
          desc = 'Sarch Neovim config files',
        },
        {
          '<leader>sf',
          function()
            builtin.find_files { find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' } }
          end,
          desc = 'Search All Files',
        },
        { '<leader>sh', builtin.help_tags, desc = 'Search Help' },
        { '<leader>sk', builtin.keymaps, desc = 'Search Keymaps' },
        { '<leader>sl', builtin.resume, desc = 'Resume Last Search' },
        {
          '<leader>sp',
          function()
            builtin.colorscheme { enable_preview = true }
          end,
          desc = 'Colorscheme with Preview',
        },
        { '<leader>ss', builtin.builtin, desc = 'Search Telescope' },
        { '<leader>st', builtin.live_grep, desc = 'Search Grep' },
        { '<leader>sw', builtin.grep_string, desc = 'Search Word' },
        { '<leader><leader>', builtin.buffers, desc = 'Find existing buffers' },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
