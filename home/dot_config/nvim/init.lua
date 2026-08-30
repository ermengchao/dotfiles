-- Interface --
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.modeline = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.breakindent = true
vim.opt.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣'
}
vim.opt.confirm = true

---- Fold ----
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldminlines = 10
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 0

---- Preview before replacement ----
vim.opt.inccommand = 'nosplit'


-- Editor --
---- Weather to substitude \t to space ----
vim.opt.expandtab = true

---- << & >> ----
vim.opt.shiftwidth = 2

---- Tab key. Follows `shiftwidth` ----
vim.opt.softtabstop = -1
vim.opt.tabstop = 8

vim.opt.undofile = true
vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)

-- Keymap --
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

---- Clear highlights on search when pressing <Esc> in normal mode ----
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


-- LSP --
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = false,
  virtual_lines = false,
  jump = { float = true },
}


-- Navigation --
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- Misc --
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
vim.api.nvim_create_user_command("W", function()
  local file = vim.fn.shellescape(vim.fn.expand("%:p"))
  vim.cmd("write !sudo tee " .. file .. " > /dev/null")
end, {})

require('plugins')
