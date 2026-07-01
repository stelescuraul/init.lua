return {
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    keymap = {
      preset = 'default',
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
      ['<CR>'] = { 'select_and_accept', 'fallback' },
    },
    appearance = {
      nerd_font_variant = 'mono',
    },
    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },
    snippets = { preset = 'default' },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
  },
  opts_extend = { 'sources.default' },
}
