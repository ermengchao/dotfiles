vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('user-blink-pack-hook', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'LuaSnip' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if vim.fn.has('win32') == 0 and vim.fn.executable('make') == 1 then
      vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add({
  { name = 'blink.lib', src = 'https://github.com/saghen/blink.lib' },
}, { load = true })

vim.pack.add({
  { name = 'blink.cmp', src = 'https://github.com/saghen/blink.cmp' },
  { name = 'LuaSnip', src = 'https://github.com/L3MON4D3/LuaSnip' },
}, { load = true })

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
