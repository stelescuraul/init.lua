return {
  -- {
  --   'github/copilot.vim',
  --   cond = function()
  --     return not vim.g.vscode
  --   end,
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_assume_mapped = true
  --     vim.keymap.set('i', '<M-l>', 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false })
  --   end,
  -- },
  --
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = '<M-l>',
        },
      },
    },
    cond = function()
      return not vim.g.vscode
    end,
  },
}
