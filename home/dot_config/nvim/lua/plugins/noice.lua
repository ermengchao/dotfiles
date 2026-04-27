vim.pack.add({
  { name = 'noice', src = 'https://github.com/folke/noice.nvim' },
  { name = 'nui', src = 'https://github.com/MunifTanjim/nui.nvim' },
}, { load = true })

require('noice').setup {
  cmdline = {
    enabled = true,
    view = 'cmdline_popup',
  },
  popupmenu = {
    enabled = true,
    backend = 'nui',
  },
  messages = {
    enabled = false,
  },
  notify = {
    enabled = false,
  },
  lsp = {
    progress = { enabled = false },
    hover = { enabled = false },
    signature = { enabled = false },
    message = { enabled = false },
  },
  presets = {
    bottom_search = false,
    command_palette = false,
    long_message_to_split = false,
    inc_rename = false,
    lsp_doc_border = false,
  },
}
