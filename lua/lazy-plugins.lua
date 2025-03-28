require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  require 'kickstart/plugins/which-key',
  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua

  -- require 'kickstart/plugins/coc',
  -- require 'kickstart/plugins/tokyonight',
  -- require 'kickstart.plugins.aerial',
  -- require 'kickstart.plugins.typescript-tools',

  require 'kickstart/plugins/gitsigns',
  require 'kickstart/plugins/telescope',
  require 'kickstart/plugins/lspconfig',
  require 'kickstart/plugins/conform',
  require 'kickstart/plugins/cmp',
  require 'kickstart/plugins/rose-pine',
  require 'kickstart/plugins/todo-comments',
  require 'kickstart/plugins/mini',
  require 'kickstart/plugins/treesitter',
  require 'kickstart.plugins.treesitter-context',
  require 'kickstart/plugins/harpoon',
  require 'kickstart/plugins/copilot',
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.markdown-preview',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

local wk = require 'which-key'
wk.add {
  { '<leader>P', group = 'Plugins' },
  { '<leader>PS', '<cmd>Lazy clear<cr>', desc = 'Status' },
  { '<leader>Pc', '<cmd>Lazy clean<cr>', desc = 'Clean' },
  { '<leader>Pd', '<cmd>Lazy debug<cr>', desc = 'Debug' },
  { '<leader>Pi', '<cmd>Lazy install<cr>', desc = 'Install' },
  { '<leader>Pl', '<cmd>Lazy log<cr>', desc = 'Log' },
  { '<leader>Pm', '<cmd>Mason<cr>', desc = 'Mason Info' },
  { '<leader>Pp', '<cmd>Lazy profile<cr>', desc = 'Profile' },
  { '<leader>Ps', '<cmd>Lazy sync<cr>', desc = 'Sync' },
  { '<leader>Pu', '<cmd>Lazy update<cr>', desc = 'Update' },
}

-- vim: ts=2 sts=2 sw=2 et
