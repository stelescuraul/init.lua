-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker',
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
          ['l'] = 'open',
          ['h'] = 'close_node',
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
        position = 'right'
      },
    },
    sources = { 'filesystem', 'document_symbols' },
  },
}
