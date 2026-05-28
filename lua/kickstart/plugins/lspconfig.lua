local utils = require 'kickstart.utils'
local icons = require 'icons'

return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    cond = function()
      return not vim.g.vscode
    end,
    dependencies = {
      {
        'williamboman/mason.nvim',
        config = true,
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- { 'yioneko/nvim-vtsls', event = 'VeryLazy' },
    },
    config = function()
      local function peek_definition()
        local bufnr = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        local methods = { 'textDocument/typeDefinition', 'textDocument/definition' }

        local function open_location(location, offset_encoding)
          local uri = location.targetUri or location.uri
          local range = location.targetSelectionRange or location.targetRange or location.range

          if not uri or not range then
            vim.notify('No definition found', vim.log.levels.INFO)
            return
          end

          local target_bufnr = vim.uri_to_bufnr(uri)
          if not vim.api.nvim_buf_is_loaded(target_bufnr) then
            vim.fn.bufload(target_bufnr)
          end

          local lines = vim.api.nvim_buf_get_lines(target_bufnr, 0, -1, false)
          local width = math.max(20, math.min(math.floor(vim.o.columns * 0.8), 120))
          local height = math.max(1, math.min(math.floor(vim.o.lines * 0.5), #lines))
          local row = math.max(0, math.floor((vim.o.lines - height) / 2 - 1))
          local col = math.max(0, math.floor((vim.o.columns - width) / 2))
          local float_bufnr = vim.api.nvim_create_buf(false, true)

          vim.bo[float_bufnr].buftype = 'nofile'
          vim.bo[float_bufnr].bufhidden = 'wipe'
          vim.bo[float_bufnr].swapfile = false
          vim.bo[float_bufnr].filetype = vim.bo[target_bufnr].filetype
          vim.bo[float_bufnr].syntax = vim.bo[target_bufnr].syntax
          vim.api.nvim_buf_set_lines(float_bufnr, 0, -1, false, lines)
          vim.bo[float_bufnr].modifiable = false
          vim.bo[float_bufnr].readonly = true

          local float_win = vim.api.nvim_open_win(float_bufnr, true, {
            border = 'rounded',
            col = col,
            height = height,
            relative = 'editor',
            row = row,
            style = 'minimal',
            title = vim.fn.fnamemodify(vim.uri_to_fname(uri), ':~:.'),
            width = width,
          })

          vim.wo[float_win].cursorline = true
          vim.wo[float_win].number = true
          vim.wo[float_win].relativenumber = false
          vim.wo[float_win].wrap = false

          local line = math.min(range.start.line + 1, #lines)
          local character = vim.str_byteindex(lines[line] or '', offset_encoding, range.start.character, false)
          vim.api.nvim_win_set_cursor(float_win, { line, character })
          vim.api.nvim_win_call(float_win, function()
            vim.cmd 'normal! zt'
          end)

          vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = float_bufnr, silent = true })
          vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = float_bufnr, silent = true })
        end

        local function request(method_index)
          local method = methods[method_index]
          local clients = method and vim.lsp.get_clients { bufnr = bufnr, method = method } or {}

          if vim.tbl_isempty(clients) then
            if methods[method_index + 1] then
              request(method_index + 1)
            else
              vim.notify('No definition provider found', vim.log.levels.INFO)
            end
            return
          end

          vim.lsp.buf_request_all(bufnr, method, function(client)
            return vim.lsp.util.make_position_params(win, client.offset_encoding)
          end, function(results)
            for client_id, response in pairs(results) do
              local result = response and response.result
              if result and not vim.tbl_isempty(result) then
                local location = vim.islist(result) and result[1] or result
                local client = vim.lsp.get_client_by_id(client_id)
                open_location(location, client and client.offset_encoding or 'utf-16')
                return
              end
            end

            if methods[method_index + 1] then
              request(method_index + 1)
            else
              vim.notify('No definition found', vim.log.levels.INFO)
            end
          end)
        end

        request(1)
      end

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local wk = require 'which-key'
          local builtin = require 'telescope.builtin'
          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          utils.map('gd', builtin.lsp_definitions, 'Goto Definition')

          -- Find references for the word under your cursor.
          utils.map('gr', builtin.lsp_references, 'Goto References')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          utils.map('gI', builtin.lsp_implementations, 'Goto Implementation')

          -- Open float window with diagnostic under cursor
          utils.map('gl', '<cmd>lua vim.diagnostic.open_float()<cr>', 'Show diagnostic')

          wk.add {
            { '<leader>l', group = 'LSP' },
            { '<leader>lD', builtin.diagnostics, desc = 'Workspace Diagnostics' },
            { '<leader>lS', builtin.lsp_dynamic_workspace_symbols, desc = 'Workspace Symbols' },
            { '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc = 'Code Action' },
            { '<leader>ld', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Buffer Diagnostics' },
            { '<leader>li', '<cmd>LspInfo<cr>', desc = 'Lsp Info' },
            { '<leader>ln', '<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<cr>', desc = 'Next Diagnostic' },
            { '<leader>lo', '<cmd>LspOrganize<cr>', desc = 'Organize Imports' },
            { '<leader>lp', '<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<cr>', desc = 'Prev Diagnostic' },
            { '<leader>lr', vim.lsp.buf.rename, desc = 'Rename' },
            { '<leader>ls', builtin.lsp_document_symbols, desc = 'Document Symbols' },
          }

          -- Opens a popup that displays documentation about the word under your cursor.
          --  See `:help K` for why this keymap.
          vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover { border = 'rounded' }
          end, { buffer = event.buf, desc = 'Hover Documentation' })

          vim.keymap.set('n', '<leader>lk', peek_definition, { buffer = event.buf, desc = 'Peek Definition' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          utils.map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            utils.map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, 'Toggle Inlay Hints')
          end

          if client and client:supports_method 'textDocument/completion' then
            local chars = {}
            for i = 32, 126 do
              chars[#chars + 1] = string.char(i)
            end
            client.server_capabilities.completionProvider.triggerCharacters = chars

            vim.lsp.completion.enable(true, client.id, event.buf, {
              autotrigger = true,
              convert = function(item)
                local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind] or 'Text'
                local kind_labels = {
                  Function = 'fn',
                  Method = 'meth',
                  Variable = 'var',
                  Field = 'field',
                  Property = 'prop',
                  Class = 'class',
                  Interface = 'iface',
                  Module = 'module',
                  File = 'file',
                  Folder = 'folder',
                  Snippet = 'snip',
                  Keyword = 'keyw',
                }
                local icon = vim.g.have_nerd_font and icons.kind[kind_name] or ''
                local label = kind_labels[kind_name] or kind_name:lower()
                local kind = icon ~= '' and string.format('%s %s', icon, label) or label

                return {
                  kind = kind,
                  kind_hlgroup = 'CompletionItemKind' .. kind_name,
                  menu = item.detail or client.name,
                }
              end,
            })

            vim.api.nvim_create_autocmd('InsertCharPre', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-completion', { clear = false }),
              buffer = event.buf,
              callback = function()
                vim.lsp.completion.get()
              end,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {
        --   filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
        -- },
        eslint = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        tsgo = {},
        -- vtsls = {
        --   settings = {
        --     vtsls = {
        --       enableMoveToFileCodeAction = true,
        --       autoUseWorkspaceTsdk = true,
        --       experimental = {
        --         completion = {
        --           enableServerSideFuzzyMatch = true,
        --         },
        --       },
        --     },
        --
        --     javascript = {
        --       format = {
        --         enable = false,
        --         insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        --         insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
        --       },
        --       updateImportsOnFileMove = { enabled = 'always' },
        --       suggest = { completeFunctionCalls = true },
        --       inlayHints = {
        --         enumMemberValues = { enabled = true },
        --         functionLikeReturnTypes = { enabled = true },
        --         parameterNames = { enabled = 'literals' },
        --         parameterTypes = { enabled = true },
        --         propertyDeclarationTypes = { enabled = true },
        --         variableTypes = { enabled = false },
        --       },
        --       implicitProjectConfig = {
        --         checkJs = true, -- enable type checking for JavaScript files
        --       },
        --     },
        --
        --     typescript = {
        --       format = {
        --         enable = false,
        --         insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        --         insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
        --       },
        --       updateImportsOnFileMove = { enabled = 'always' },
        --       suggest = { completeFunctionCalls = true },
        --       tsserver = {
        --         maxTsServerMemory = 1024 * 5,
        --       },
        --       implicitProjectConfig = {
        --         checkJs = true, -- enable type checking for JavaScript files
        --       },
        --       inlayHints = {
        --         enumMemberValues = { enabled = true },
        --         functionLikeReturnTypes = { enabled = true },
        --         parameterNames = { enabled = 'literals' },
        --         parameterTypes = { enabled = true },
        --         propertyDeclarationTypes = { enabled = true },
        --         variableTypes = { enabled = false },
        --       },
        --     },
        --   },
        --   handlers = {
        --     ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
        --       if result.diagnostics == nil then
        --         return
        --       end
        --
        --       local diagnostic_bufnr = vim.uri_to_bufnr(result.uri)
        --       local current_bufnr = vim.api.nvim_get_current_buf()
        --
        --       -- If the diagnostic is not for the buffer you are looking at, do nothing.
        --       if diagnostic_bufnr ~= current_bufnr then
        --         vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        --         return
        --       end
        --
        --       local filetype = vim.api.nvim_buf_get_option(current_bufnr, 'filetype')
        --
        --       -- ignore some tsserver diagnostics
        --       local idx = 1
        --       while idx <= #result.diagnostics do
        --         local entry = result.diagnostics[idx]
        --
        --         -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
        --
        --         if
        --           -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
        --           entry.code == 80001
        --           -- { message = "Parameter 'x' implicitly has an 'any' type." }
        --           -- { message = "Variable 'x' implicitly has an 'any' type." }
        --           or ((entry.code == 7006 or entry.code == 7031) and filetype == 'javascript')
        --         then
        --           -- This error will only be removed for javascript files
        --           table.remove(result.diagnostics, idx)
        --         else
        --           idx = idx + 1
        --         end
        --       end
        --
        --       vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        --     end,
        --   },
        -- },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = {
        'stylua', -- Used to format Lua code
        'markdownlint',
        'prettierd',
      }
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers or {}),
        automatic_installation = false,
        automatic_enable = false,
      }

      for name, config in pairs(servers) do
        local config = config or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for ts_ls)
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
