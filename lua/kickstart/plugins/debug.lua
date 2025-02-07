-- debug.lua

return {
  'mfussenegger/nvim-dap',
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- js/node debug. Compiled from source
    {
      'microsoft/vscode-js-debug',
      version = '1.x',
      build = 'npm i && npm run compile dapDebugServer && mv dist out',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    }

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        -- 💀 Make sure to update this path to point to your installation
        args = { vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug/out/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.defaults.fallback.external_terminal = {
      command = '/bin/zsh',
    }

    local js_based_languages = { 'typescript', 'javascript' }

    for _, language in ipairs(js_based_languages) do
      require('dap').configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        -- {
        --   type = 'pwa-chrome',
        --   request = 'launch',
        --   name = 'Start Chrome with "localhost"',
        --   url = 'http://localhost:3000',
        --   webRoot = '${workspaceFolder}',
        --   userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
        -- },
        {
          protocol = 'inspector',
          type = 'pwa-node',
          request = 'launch',
          name = 'Jest run current file',
          program = '${workspaceFolder}/node_modules/.bin/jest',
          args = { '--colors', '--runInBand', '${file}' },
          runtimeExecutable = 'fnm',
          runtimeArgs = { 'exec', 'node', '--' },
          internalConsoleOptions = 'openOnSessionStart',
          console = 'integratedTerminal',
          cwd = '${workspaceFolder}',
          outputCapture = 'integratedTerminal',
          env = { NODE_ENV = 'test' },
          skipFiles = { '<node_internals>/**' },
          resolveSourceMapLocations = { '**', '!**/node_modules/**' },
        },
        {
          protocol = 'inspector',
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch API',
          runtimeExecutable = 'fnm',
          runtimeArgs = { 'exec', 'npm', 'run', 'start:web' },
          internalConsoleOptions = 'openOnSessionStart',
          console = 'integratedTerminal',
          outputCapture = 'integratedTerminal',
          env = {
            NO_HOTRELOAD = 'true',
            USE_TSNODE = 'true',
          },
          skipFiles = { '<node_internals>/**', 'node_modules/**' },
          cwd = '${workspaceFolder}',
          resolveSourceMapLocations = { '**', '!**/node_modules/**' },
        },
        {
          protocol = 'inspector',
          type = 'pwa-node',
          request = 'launch',
          name = 'Mocha Test current file',
          program = '${workspaceFolder}/node_modules/.bin/mocha',
          args = { '--colors', '--timeout', '0', '${file}' },
          runtimeExecutable = 'fnm',
          runtimeArgs = { 'exec', 'node', '--' },
          internalConsoleOptions = 'openOnSessionStart',
          console = 'integratedTerminal',
          cwd = '${workspaceFolder}',
          outputCapture = 'integratedTerminal',
          env = { USE_TSNODE = 'true' },
          skipFiles = { '<node_internals>/**' },
          resolveSourceMapLocations = { '**', '!**/node_modules/**' },
        },
      }
    end

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Debug: Step Out' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
        element = '',
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Toggle the DAP UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
