return {
  {
    'ruifm/gitlinker.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },

    keys = {
      {
        '<leader>gO',
        function()
          require('gitlinker').get_buf_range_url('n', { action_callback = require('gitlinker.actions').open_in_browser })
        end,
        mode = { 'n' },
        desc = 'Open URL for selected lines',
      },
      {
        '<leader>gO',
        function()
          require('gitlinker').get_buf_range_url('v', { action_callback = require('gitlinker.actions').open_in_browser })
        end,
        mode = { 'v' },
        desc = 'Open URL for selected lines',
      },
    },

    opts = {
      print_url = true,
    },
  },
}
