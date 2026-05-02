vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  { name = 'yazi.nvim', src = 'https://github.com/mikavilpas/yazi.nvim' },
  { name = 'plenary', src = 'https://github.com/nvim-lua/plenary.nvim' },
}, { load = true })

require('yazi').setup {
  open_for_directories = true,
  keymaps = {
    show_help = '<f1>',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>-', '<cmd>Yazi<cr>', { desc = 'Open yazi at the current file' })
vim.keymap.set('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = "Open the file manager in nvim's working directory" })
vim.keymap.set('n', '<C-Up>', '<cmd>Yazi toggle<cr>', { desc = 'Resume the last yazi session' })
