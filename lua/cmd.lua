-- Organize imports
_G.lsp_organize_imports_sync = function(bufnr)
  -- gets the current bufnr if no bufnr is passed
  if not bufnr then
    bufnr = vim.api.nvim_get_current_buf()
  end

  -- params for the request
  local params = {
    command = '_typescript.organizeImports',
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
    title = '',
  }

  -- perform a syncronous request
  -- 500ms timeout depending on the size of file a bigger timeout may be needed
  vim.lsp.buf_request(bufnr, 'workspace/executeCommand', params)
end
vim.cmd 'command! LspOrganize lua lsp_organize_imports_sync()'
