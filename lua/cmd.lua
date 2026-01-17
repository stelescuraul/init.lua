-- Organize imports
-- _G.lsp_organize_imports_sync = function(bufnr)
--   -- gets the current bufnr if no bufnr is passed
--   if not bufnr then
--     bufnr = vim.api.nvim_get_current_buf()
--   end
--
--   -- params for the request
--   local params = {
--     command = '_typescript.organizeImports',
--     arguments = { vim.api.nvim_buf_get_name(bufnr) },
--     title = '',
--   }
--
--   -- perform a syncronous request
--   -- 500ms timeout depending on the size of file a bigger timeout may be needed
--   vim.lsp.buf_request(bufnr, 'workspace/executeCommand', params)
-- end
-- vim.cmd 'command! LspOrganize lua lsp_organize_imports_sync()'

vim.cmd 'command! LspOrganize VtsExec organize_imports'

local function fix_all(opts)
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  vim.validate('bufnr', bufnr, 'number')

  local client = opts.client or vim.lsp.get_clients({ bufnr = bufnr, name = 'eslint' })[1]

  if not client then
    return
  end

  local request = function(buf, method, params)
    client:request(method, params, nil, buf)
  end

  request(bufnr, 'workspace/executeCommand', {
    command = 'eslint.applyAllFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  })
end

vim.api.nvim_create_user_command('EslintFixAll', function()
  fix_all {}
end, {})
