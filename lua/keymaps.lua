local utils = require 'kickstart.utils'
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear highlight' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })

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
    vim.highlight.on_yank()
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

-- copilot
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap('i', '<M-l>', 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- visual comment
vim.keymap.set('v', '<leader>/', '<Plug>(comment_toggle_linewise_visual)')

-- Window size management
utils.map('<M-Up>', '<cmd>resize +2<cr>', 'Increase Window Height')
utils.map('<M-Down>', '<cmd>resize -2<cr>', 'Decrease Window Height')
utils.map('<M-Left>', '<cmd>vertical resize -2<cr>', 'Decrease Window Width')
utils.map('<M-Right>', '<cmd>vertical resize +2<cr>', 'Increase Window Width')


