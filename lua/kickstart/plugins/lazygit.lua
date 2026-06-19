return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  init = function()
    vim.g.lazygit_use_neovim_remote = 1
    vim.g.lazygit_use_custom_config_file_path = 1
    vim.g.lazygit_config_file_path = vim.fn.stdpath 'config' .. '/lazygit.yml'

    _G.LazyGitOpenFile = function(encoded_path)
      local path = vim.base64.decode(encoded_path)
      local lazygit_win = vim.api.nvim_get_current_win()
      local lazygit_buf = vim.api.nvim_win_get_buf(lazygit_win)
      local parent_win = vim.g.lazygit_parent_win

      -- Queue a normal LazyGit exit. It is processed after the opener returns,
      -- allowing lazygit.nvim to run its regular cleanup callback.
      vim.api.nvim_chan_send(vim.bo[lazygit_buf].channel, 'q')

      if parent_win and vim.api.nvim_win_is_valid(parent_win) then
        vim.api.nvim_set_current_win(parent_win)
      end

      vim.cmd.edit(vim.fn.fnameescape(path))
      return 0
    end
  end,
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    {
      '<leader>gg',
      function()
        vim.g.lazygit_parent_win = vim.api.nvim_get_current_win()
        vim.cmd.LazyGit()
      end,
      desc = 'LazyGit',
    },
  },
}
