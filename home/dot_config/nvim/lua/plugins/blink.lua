vim.pack.add({
  {
    name = "blink.lib",
    src = "https://github.com/saghen/blink.lib"
  }
})

vim.pack.add({
  {
    name = "blink.cmp",
    src = "https://github.com/saghen/blink.cmp"
  },
  {
    name = "LuaSnip",
    src = "https://github.com/L3MON4D3/LuaSnip"
  }
}, {
  load = true
})

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
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
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
