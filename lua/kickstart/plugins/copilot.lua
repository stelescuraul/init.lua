return {
  {
    'github/copilot.vim',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.keymap.set('i', '<M-l>', 'copilot#Accept("<CR>")', { silent = true, expr = true, replace_keycodes = false })
    end,
  },
}
