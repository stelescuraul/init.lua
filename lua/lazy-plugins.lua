require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'stevearc/dressing.nvim',
    opts = {},
  },

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua

  require 'kickstart/plugins/gitsigns',

  require 'kickstart/plugins/which-key',

  require 'kickstart/plugins/telescope',

  require 'kickstart/plugins/lspconfig',

  require 'kickstart/plugins/conform',

  require 'kickstart/plugins/cmp',

  require 'kickstart/plugins/tokyonight',

  require 'kickstart/plugins/todo-comments',

  require 'kickstart/plugins/mini',

  require 'kickstart/plugins/treesitter',

  require 'kickstart.plugins.treesitter-context',

  require 'kickstart/plugins/harpoon',

  -- require 'kickstart/plugins/copilot',

  -- require 'kickstart.plugins.debug',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.aerial',
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
wk.register({
  ['P'] = {
    name = 'Plugins',
    i = { '<cmd>Lazy install<cr>', 'Install' },
    s = { '<cmd>Lazy sync<cr>', 'Sync' },
    S = { '<cmd>Lazy clear<cr>', 'Status' },
    c = { '<cmd>Lazy clean<cr>', 'Clean' },
    u = { '<cmd>Lazy update<cr>', 'Update' },
    p = { '<cmd>Lazy profile<cr>', 'Profile' },
    l = { '<cmd>Lazy log<cr>', 'Log' },
    d = { '<cmd>Lazy debug<cr>', 'Debug' },
  },
}, {
  prefix = '<leader>',
})

-- vim: ts=2 sts=2 sw=2 et
