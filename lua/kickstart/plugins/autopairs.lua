-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require('nvim-autopairs').setup {}
  end,
}
