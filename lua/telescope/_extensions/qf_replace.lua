-- lua/telescope/_extensions/qf_replace.lua
local ok, telescope = pcall(require, 'telescope')
if not ok then
  error 'qf_replace requires nvim-telescope/telescope.nvim'
end

local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local M = {}

local function esc_delim(s, d)
  return s:gsub(d, '\\' .. d)
end
local function esc_vimgrep(s)
  return s:gsub('/', '\\/')
end

local function set_qf(items, title)
  vim.fn.setqflist({}, ' ', { title = title or 'qf_replace', items = items })
end

local function get_selection(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  if not picker then
    return nil
  end
  local sel = picker:get_multi_selection()
  if sel and #sel > 0 then
    return sel
  end
  return nil
end

local function highlight_on(find)
  return vim.fn.matchadd('IncSearch', find)
end
local function highlight_off(id)
  if id and id > 0 then
    pcall(vim.fn.matchdelete, id)
  end
end

function M.qf_replace(opts)
  opts = opts or {}

  vim.ui.input({ prompt = 'Find (Vim regex): ' }, function(find)
    if not find or find == '' then
      return
    end
    if opts.ignorecase and not (find:find '\\c' or find:find '\\C') then
      find = '\\c' .. find
    end

    local hl = highlight_on(find)

    vim.ui.input({ prompt = 'Replace with: ' }, function(repl)
      if repl == nil then
        highlight_off(hl)
        return
      end

      -- Populate quickfix from current buffer (%)
      vim.cmd(('silent! vimgrep /%s/j %%'):format(esc_vimgrep(find)))

      builtin.quickfix {
        prompt_title = 'qf_replace (buffer) — <Tab> mark, <Enter> replace',
        attach_mappings = function(prompt_bufnr, map)
          -- Tab multi-select
          map('i', '<Tab>', function(bufnr)
            actions.toggle_selection(bufnr)
            actions.move_selection_next(bufnr)
          end)
          map('n', '<Tab>', function(bufnr)
            actions.toggle_selection(bufnr)
            actions.move_selection_next(bufnr)
          end)

          local function apply()
            -- read selection BEFORE closing
            local sel = get_selection(prompt_bufnr)

            actions.close(prompt_bufnr)
            highlight_off(hl)

            -- if user selected items, restrict qf to those; else keep full qf
            if sel then
              set_qf(sel, 'qf_replace (selected)')
            end

            local d = '@'
            local find_s = esc_delim(find, d)
            local repl_s = esc_delim(repl, d)
            local flags = 'g' .. (opts.confirm and 'c' or '')

            vim.cmd(('silent! cdo s%s%s%s%s%s%s | update'):format(d, find_s, d, repl_s, d, flags))
            vim.notify(sel and 'Replaced selected matches.' or 'Replaced all matches.', vim.log.levels.INFO)
          end

          actions.select_default:replace(apply)

          map('n', '<Esc>', function()
            highlight_off(hl)
            actions.close(prompt_bufnr)
          end)

          return true
        end,
      }
    end)
  end)
end

return telescope.register_extension {
  exports = { qf_replace = M.qf_replace },
}
