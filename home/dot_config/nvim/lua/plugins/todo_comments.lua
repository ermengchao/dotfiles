vim.pack.add({
  { name = 'todo-comments', src = 'https://github.com/folke/todo-comments.nvim' },
  { name = 'plenary', src = 'https://github.com/nvim-lua/plenary.nvim' },
}, { load = true })

require('todo-comments').setup { signs = false }
