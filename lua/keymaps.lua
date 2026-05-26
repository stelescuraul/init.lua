local utils = require 'kickstart.utils'
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear highlight' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next Diagnostic message' })

--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_user_command('BufferKill', function()
  utils.buf_kill 'bd'
end, { force = false })

vim.keymap.set('n', 'J', 'mzJ`z') -- Join lines but keep the cursor in place
vim.keymap.set('n', '<C-d>', '<C-d>zz') -- keep cursor in middle when going down
vim.keymap.set('n', '<C-u>', '<C-u>zz') -- keep cursor in middle when going down
vim.keymap.set('n', 'n', 'nzzzv') -- keep cursor in middle when searching
vim.keymap.set('n', 'N', 'Nzzzv') -- keep cursor in middle when searching

vim.keymap.set('n', '<leader>/', 'gcc', { desc = 'Comment toggle current line', remap = true })
vim.keymap.set('v', '<leader>/', 'gc', { desc = 'Comment toggle selection', remap = true })

vim.keymap.set('i', '<C-j>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<C-j>'
end, { desc = 'Select next completion item', expr = true, replace_keycodes = true })

vim.keymap.set('i', '<C-k>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-k>'
end, { desc = 'Select previous completion item', expr = true, replace_keycodes = true })

vim.keymap.set('i', '<C-Space>', function()
  vim.lsp.completion.get()
end, { desc = 'Trigger LSP completion' })

vim.cmd [[inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"]]

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end

  if vim.snippet.active { direction = 1 } then
    return '<Cmd>lua vim.snippet.jump(1)<CR>'
  end

  return '<Tab>'
end, { desc = 'Accept completion or jump snippet', expr = true, replace_keycodes = true })

vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if vim.snippet.active { direction = 1 } then
    return '<Cmd>lua vim.snippet.jump(1)<CR>'
  end

  return '<C-l>'
end, { desc = 'Jump to next snippet placeholder', expr = true, replace_keycodes = true })

vim.keymap.set({ 'i', 's' }, '<C-h>', function()
  if vim.snippet.active { direction = -1 } then
    return '<Cmd>lua vim.snippet.jump(-1)<CR>'
  end

  return '<C-h>'
end, { desc = 'Jump to previous snippet placeholder', expr = true, replace_keycodes = true })

-- Window size management
utils.map('<M-Up>', '<cmd>resize +2<cr>', 'Increase Window Height')
utils.map('<M-Down>', '<cmd>resize -2<cr>', 'Decrease Window Height')
utils.map('<M-Left>', '<cmd>vertical resize -2<cr>', 'Decrease Window Width')
utils.map('<M-Right>', '<cmd>vertical resize +2<cr>', 'Increase Window Width')
