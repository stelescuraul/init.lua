-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
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
            },
            -- for normal mode
            n = {
              ['<C-j>'] = 'move_selection_next',
              ['<C-k>'] = 'move_selection_previous',
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
          -- path_display
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
              --   i = {
              --     ['<C-d>'] = require('telescope.actions').delete_buffer,
              --   },
              n = {
                ['dd'] = function(buffnr)
                  require('telescope.actions').delete_buffer(buffnr)
                end,
              },
            },
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local wk = require 'which-key'
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      wk.register({
        ['s'] = {
          name = 'Search',
          h = { builtin.help_tags, 'Search Help' },
          k = { builtin.keymaps, 'Search Keymaps' },
          f = {
            function()
              builtin.find_files { find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' } }
            end,
            'Search All Files',
          },
          F = {
            builtin.current_buffer_fuzzy_find,
            'Fuzzy find in buffer',
          },
          s = { builtin.builtin, 'Search Telescope' },
          w = { builtin.grep_string, 'Search Word' },
          t = { builtin.live_grep, 'Search Grep' },
          l = { builtin.resume, 'Resume Last Search' },
          ['.'] = { builtin.oldfiles, 'Search Recent Files' },
          p = {
            function()
              builtin.colorscheme { enable_preview = true }
            end,
            'Colorscheme with Preview',
          },
          c = {
            function()
              builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end,
            'Sarch Neovim config files',
          },
        },
        ['f'] = { builtin.find_files, 'Search files' },
        ['b'] = {
          f = { builtin.buffers, 'Find Buffers' },
        },
      }, {
        prefix = '<leader>',
      })

      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
