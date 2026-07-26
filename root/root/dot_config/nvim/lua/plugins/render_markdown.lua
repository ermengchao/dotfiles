vim.pack.add({
  { name = 'render-markdown', src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { name = 'nvim-treesitter', src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { name = 'mini.nvim', src = 'https://github.com/nvim-mini/mini.nvim' },
}, { load = true })

require('render-markdown').setup {
  code = {
    width = 'block',
    border = 'thin',
    left_pad = 1,
    right_pad = 1,
    position = 'left',
  },
}
