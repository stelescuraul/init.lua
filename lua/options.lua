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

vim.opt.pumheight = 15
vim.opt.pumborder = 'rounded'
vim.opt.winborder = 'rounded'
vim.opt.completeitemalign = 'abbr,kind,menu'
vim.opt.completeopt = { 'menuone', 'noselect', 'popup', 'fuzzy' }

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

local function set_completion_doc_border(winid)
  if not winid or winid == 0 or not vim.api.nvim_win_is_valid(winid) then
    return
  end

  local border = vim.o.pumborder ~= '' and vim.o.pumborder or vim.o.winborder
  if border == '' then
    return
  end

  pcall(vim.api.nvim_win_set_config, winid, { border = border })
end

if vim.api.nvim__complete_set and not vim.g.kickstart_completion_doc_border then
  vim.g.kickstart_completion_doc_border = true
  local complete_set = vim.api.nvim__complete_set

  vim.api.nvim__complete_set = function(index, opts)
    local windata = complete_set(index, opts)
    if type(windata) == 'table' then
      set_completion_doc_border(windata.winid)
    end
    return windata
  end
end

local function set_completion_highlights()
  vim.api.nvim_set_hl(0, 'PmenuBorder', { link = 'FloatBorder' })
  vim.api.nvim_set_hl(0, 'PmenuKind', { link = 'NonText' })
  vim.api.nvim_set_hl(0, 'PmenuKindSel', { link = 'PmenuSel' })
  vim.api.nvim_set_hl(0, 'PmenuExtra', { link = 'Comment' })
  vim.api.nvim_set_hl(0, 'PmenuExtraSel', { link = 'PmenuSel' })
  vim.api.nvim_set_hl(0, 'PmenuMatch', { link = 'Search' })
  vim.api.nvim_set_hl(0, 'PmenuMatchSel', { link = 'PmenuSel' })

  vim.api.nvim_set_hl(0, 'CompletionItemKindFunction', { link = 'Function' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindMethod', { link = 'Function' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindVariable', { link = 'Identifier' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindField', { link = 'Identifier' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindProperty', { link = 'Identifier' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindClass', { link = 'Type' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindInterface', { link = 'Type' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindModule', { link = 'Include' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindFile', { link = 'Directory' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindFolder', { link = 'Directory' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindSnippet', { link = 'Special' })
  vim.api.nvim_set_hl(0, 'CompletionItemKindKeyword', { link = 'Keyword' })
end

set_completion_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('completion-highlights', { clear = true }),
  callback = set_completion_highlights,
})

vim.api.nvim_create_autocmd('CompleteChanged', {
  group = vim.api.nvim_create_augroup('completion-doc-border', { clear = true }),
  callback = function()
    vim.schedule(function()
      local ok, info = pcall(vim.fn.complete_info, { 'preview_winid' })
      if ok then
        set_completion_doc_border(info.preview_winid)
      end
    end)
  end,
})
