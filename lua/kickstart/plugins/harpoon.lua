local utils = require 'kickstart.utils'

return {
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    config = function()
      local harpoon = require 'harpoon'
      local wk = require 'which-key'

      harpoon:setup()

      wk.register({
        ['a'] = {
          name = 'Harpoon',
          a = {
            function()
              harpoon:list():add()
            end,
            'Add',
          },
          q = {
            function()
              harpoon:list():select(1)
            end,
            'Buffer 1',
          },
          w = {
            function()
              harpoon:list():select(2)
            end,
            'Buffer 2',
          },
          e = {
            function()
              harpoon:list():select(3)
            end,
            'Buffer 3',
          },
          r = {
            function()
              harpoon:list():select(4)
            end,
            'Buffer 4',
          },
        },
      }, {
        prefix = '<leader>',
      })

      utils.map('<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, 'Quick toggle')
    end,
  },
}
