vim.pack.add({
  { name = 'neo-tree', src = 'https://github.com/nvim-neo-tree/neo-tree.nvim' },
  { name = 'plenary', src = 'https://github.com/nvim-lua/plenary.nvim' },
  { name = 'nvim-web-devicons', src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { name = 'nui', src = 'https://github.com/MunifTanjim/nui.nvim' },
}, { load = true })

require('neo-tree').setup {
  filesystem = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}

vim.keymap.set('n', '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })
