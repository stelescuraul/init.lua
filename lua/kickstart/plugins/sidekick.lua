local function sidekick_target_win(current_win)
  local previous_win = vim.fn.win_getid(vim.fn.winnr '#')

  if previous_win ~= 0 and vim.api.nvim_win_is_valid(previous_win) and previous_win ~= current_win and not vim.w[previous_win].sidekick_cli then
    return previous_win
  end

  local fallback_win
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if
      win ~= current_win
      and not vim.w[win].sidekick_cli
      and (not fallback_win or (vim.w[win].sidekick_visit or 0) > (vim.w[fallback_win].sidekick_visit or 0))
    then
      fallback_win = win
    end
  end

  return fallback_win
end

local function clean_file_candidate(candidate)
  candidate = vim.trim(candidate or '')
  candidate = candidate:gsub('^[`"\'%[%(%{@]+', '')
  candidate = candidate:gsub('[`"\',;%)%]}%.]+$', '')

  if candidate:sub(1, 7) == 'file://' then
    candidate = vim.uri_to_fname(candidate)
  end

  local path, line, col = candidate:match '^(.+):(%d+):(%d+)$'
  if not path then
    path, line = candidate:match '^(.+):(%d+)$'
  end

  return path or candidate, tonumber(line), tonumber(col)
end

local function resolve_file_candidate(candidate, cwd)
  local path, line, col = clean_file_candidate(candidate)

  if path == '' then
    return
  end

  local expanded = vim.fn.expand(path)
  if vim.fn.filereadable(expanded) == 1 then
    return expanded, line, col
  end

  local cwd_path = vim.fs.joinpath(cwd or vim.fn.getcwd(), path)
  if vim.fn.filereadable(cwd_path) == 1 then
    return cwd_path, line, col
  end
end

local function open_sidekick_file(terminal)
  local current_win = vim.api.nvim_get_current_win()
  local path, line, col

  for _, candidate in ipairs { vim.fn.expand '<cWORD>', vim.fn.expand '<cfile>' } do
    path, line, col = resolve_file_candidate(candidate, terminal.cwd)
    if path then
      break
    end
  end

  if not path then
    vim.notify('No readable file under cursor', vim.log.levels.WARN)
    return
  end

  local target_win = sidekick_target_win(current_win)
  if target_win then
    vim.api.nvim_set_current_win(target_win)
    vim.cmd.edit(vim.fn.fnameescape(path))
  else
    vim.cmd('leftabove vsplit ' .. vim.fn.fnameescape(path))
  end

  if line then
    pcall(vim.api.nvim_win_set_cursor, 0, { line, math.max((col or 1) - 1, 0) })
  end
end

return {
  'folke/sidekick.nvim',
  opts = {
    cli = {
      win = {
        keys = {
          goto_file = { 'gf', open_sidekick_file, mode = 'n', desc = 'Open file in editor window' },
        },
      },
    },
    -- cli = {
    --   mux = {
    --     backend = 'zellij',
    --     enabled = true,
    --   },
    -- },
  },
  keys = {
    {
      '<tab>',
      function()
        if vim.fn.pumvisible() == 1 then
          return '<C-y>'
        end

        if vim.snippet.active { direction = 1 } then
          return '<Cmd>lua vim.snippet.jump(1)<CR>'
        end

        -- if there is a next edit, jump to it, otherwise apply it if any
        if require('sidekick').nes_jump_or_apply() then
          return -- jumped or applied
        end

        -- fall back to normal tab
        return '<tab>'
      end,
      mode = { 'i', 'n' },
      expr = true,
      replace_keycodes = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<c-.>',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle',
      mode = { 'n', 't', 'i', 'x' },
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle CLI',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = 'Select CLI',
    },
    {
      '<leader>ad',
      function()
        require('sidekick.cli').close()
      end,
      desc = 'Detach a CLI Session',
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}' }
      end,
      mode = { 'x', 'n' },
      desc = 'Send This',
    },
    {
      '<leader>af',
      function()
        require('sidekick.cli').send { msg = '{file}' }
      end,
      desc = 'Send File',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Send Visual Selection',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick Select Prompt',
    },
    -- Example of a keybinding to open Claude directly
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle { name = 'claude', focus = true }
      end,
      desc = 'Sidekick Toggle Claude',
    },
  },
}
