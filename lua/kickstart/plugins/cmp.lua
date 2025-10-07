return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    cond = function()
      return not vim.g.vscode
    end,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      -- 'onsails/lspkind.nvim',
    },
    config = function()
      -- See `:help cmp`
      -- local lspkind = require 'lspkind'
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local icons = require 'icons'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the next item
          ['<C-j>'] = cmp.mapping.select_next_item(),
          -- Select the previous item
          ['<C-k>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          -- ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.confirm { select = true },
          -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = (icons.cmp[vim_item.kind] or '') .. vim_item.kind
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              buffer = '[Buffer]',
              luasnip = '[LuaSnip]',
              nvim_lua = '[Lua]',
            })[entry.source.name]

            return vim_item
          end,
          -- format = lspkind.cmp_format {
          --   mode = 'text_symbol', -- show only symbol annotations
          --   maxwidth = {
          --     -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          --     -- can also be a function to dynamically calculate max width such as
          --     -- menu = function() return math.floor(0.45 * vim.o.columns) end,
          --     menu = 50, -- leading text (labelDetails)
          --     abbr = 50, -- actual suggestion item
          --   },
          --   ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          --   show_labelDetails = true, -- show labelDetails in menu. Disabled by default
          --
          --   -- The function below will be called before any actual modifications from lspkind
          --   -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          --   before = function(entry, vim_item)
          --     -- ...
          --     vim_item.menu = ({
          --       nvim_lsp = '[LSP]',
          --       buffer = '[Buffer]',
          --       luasnip = '[LuaSnip]',
          --       nvim_lua = '[Lua]',
          --     })[entry.source.name]
          --
          --     return vim_item
          --   end,
          -- },
        },
        sources = {
          {
            name = 'nvim_lsp',
            priority = 1000,
            entry_filter = function(entry, ctx)
              -- filter out TEXT type from lsp
              if entry:get_kind() == 1 then
                return false
              end

              return true;
            end,
          },
          { name = 'luasnip', priority = 800 },
          { name = 'path' },
          { name = 'buffer', priority = 700 },
        },
        window = {
          documentation = {
            max_height = 10,
          },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
