-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      config = function()
        require('window-picker').setup {
          selection_chars = '123456789',
          show_prompt = true,
          highlights = {
            enabled = false,
            statusline = {
              focused = {
                fg = '#ededed',
                bg = '#e35e4f',
                bold = true,
              },
              unfocused = {
                fg = '#ededed',
                bg = '#f89595',
                bold = true,
              },
            },
          },
        }
      end,
    },
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
    { '<leader>ba', ':Neotree document_symbols<cr>', { desc = 'Document symbols' } },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['<leader>e'] = 'close_window',
          ['w'] = {},
          ['<cr>'] = 'open_with_window_picker',
          ['l'] = 'open_with_window_picker',
          ['h'] = 'close_node',
          ['S'] = 'split_with_window_picker',
          ['s'] = 'vsplit_with_window_picker',
        },
      },
    },
    document_symbols = {
      window = {
        mappings = {
          ['<leader>e'] = 'close_window',
          ['w'] = {},
          ['l'] = 'open',
          ['h'] = 'close_node',
        },
        position = 'right',
        window_picker = {
          enable = true,
        },
      },
    },
    sources = { 'filesystem', 'document_symbols' },
  },
}
