vim.pack.add({
  { name = 'typst-preview', src = 'https://github.com/chomosuke/typst-preview.nvim' },
}, { load = true })

require('typst-preview').setup {}
