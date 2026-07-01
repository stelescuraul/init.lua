require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { 'EdenEast/nightfox.nvim', name = 'nightfox', priority = 1000 },

  require 'kickstart/plugins/which-key',

  -- modular approach: using `require 'path/name'` will
  -- include a plugin definition from file lua/path/name.lua

  -- require 'kickstart/plugins/tokyonight',
  { 'stevearc/dressing.nvim', opts = {} },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  require 'kickstart/plugins/treesitter',
  require 'kickstart/plugins/treesitter-context',

  require 'kickstart/plugins/gitsigns',
  require 'kickstart/plugins/telescope',
  require 'kickstart/plugins/blink-cmp',
  require 'kickstart/plugins/lspconfig',
  require 'kickstart/plugins/conform',
  require 'kickstart/plugins/rose-pine',
  require 'kickstart/plugins/todo-comments',
  require 'kickstart/plugins/mini',
  require 'kickstart/plugins/harpoon',
  require 'kickstart/plugins/copilot',
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.markdown-preview',

  require 'kickstart.plugins.gitlinker',

  require 'kickstart.plugins.github',
  require 'kickstart.plugins.sidekick',
  require 'kickstart.plugins.lazygit',

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

-- vim: ts=2 sts=2 sw=2 et
