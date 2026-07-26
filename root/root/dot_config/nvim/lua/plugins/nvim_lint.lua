vim.pack.add {{
  name = 'nvim-lint',
  src = 'https://github.com/mfussenegger/nvim-lint',
}}

local lint = require 'lint'

lint.linters_by_ft = {
  markdown = { 'markdownlint' },
}

local lint_augroup = vim.api.nvim_create_augroup('user-lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then lint.try_lint() end
  end,
})
