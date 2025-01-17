return {
  {
    'rose-pine/neovim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    cond = function()
      return not vim.g.vscode
    end,
    init = function()
      vim.cmd.colorscheme 'rose-pine-moon'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
