return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      multiline_threshold = 1,
      max_lines = 4,
    },
    cond = function()
      return not vim.g.vscode
    end,
  },
}
