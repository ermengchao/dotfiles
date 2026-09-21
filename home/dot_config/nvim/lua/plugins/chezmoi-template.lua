vim.pack.add {{
  name = 'chezmoi-template',
  src = 'https://github.com/dpezto/chezmoi-template.nvim',
}}

require('chezmoi-template').setup {
  format = {
    enabled = true,
  },
  apply = {
    on_save = true,
  },
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user-chezmoi-template', { clear = true }),
  pattern = 'gotmpl',
  callback = function(args)
    vim.b[args.buf].autoformat = false
    vim.b[args.buf].disable_autoformat = true
  end,
})
