-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 50
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.termguicolors = true

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = false

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

vim.opt.winborder = 'rounded'

local checktime_timer
local function check_external_changes()
  if checktime_timer then
    return
  end

  checktime_timer = vim.defer_fn(function()
    checktime_timer = nil
    if vim.fn.mode() ~= 'c' then
      vim.cmd 'silent! checktime'
    end
  end, 200)
end

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('external-file-changes', { clear = true }),
  callback = check_external_changes,
})
