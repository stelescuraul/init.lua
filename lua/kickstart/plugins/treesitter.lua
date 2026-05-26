return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    cond = function()
      return not vim.g.vscode
    end,
    lazy = false,
    config = function()
      local treesitter = require 'nvim-treesitter'

      treesitter.setup {
        install_dir = vim.fn.stdpath 'data' .. '/site',
      }

      local parsers = {
        'bash',
        'c',
        'diff',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
        'typescript',
        'javascript',
        'json',
        'query',
      }

      treesitter.install(parsers)

      local filetypes = {
        'bash',
        'c',
        'diff',
        'javascript',
        'json',
        'lua',
        'markdown',
        'query',
        'sh',
        'typescript',
        'vim',
        'vimdoc',
      }

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        pattern = filetypes,
        callback = function()
          if pcall(vim.treesitter.start) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
