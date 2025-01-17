return {
  {
    'iamcco/markdown-preview.nvim',
    cond = function()
      return not vim.g.vscode
    end,
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
}
