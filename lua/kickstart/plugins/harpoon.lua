local utils = require 'kickstart.utils'

return {
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    cond = function()
      return not vim.g.vscode
    end,
    config = function()
      local harpoon = require 'harpoon'
      local wk = require 'which-key'

      harpoon:setup {
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      }

      wk.add {
        { '<leader>a', group = 'Harpoon' },
        {
          '<leader>aa',
          function()
            harpoon:list():add()
          end,
          desc = 'Add',
        },
        {
          '<leader>aq',
          function()
            harpoon:list():select(1)
          end,
          desc = 'Buffer 3',
        },
        {
          '<leader>aw',
          function()
            harpoon:list():select(2)
          end,
          desc = 'Buffer 1',
        },
        {
          '<leader>ae',
          function()
            harpoon:list():select(3)
          end,
          desc = 'Buffer 4',
        },
        {
          '<leader>ar',
          function()
            harpoon:list():select(4)
          end,
          desc = 'Buffer 2',
        },
      }

      utils.map('<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, 'Quick toggle')
    end,
  },
}
