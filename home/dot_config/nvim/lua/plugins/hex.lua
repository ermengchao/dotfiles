vim.pack.add({
  {
    name = "hex",
    src = "https://github.com/RaafatTurki/hex.nvim",
  },
})

local hex = require("hex")
local default_pre_read = hex.cfg.is_file_binary_pre_read

hex.setup({
  dump_cmd = "xxd -g 1 -u",
  assemble_cmd = "xxd -r",
  is_file_binary_pre_read = function()
    return vim.fn.expand("%:e"):lower() == "mfd" or default_pre_read()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.mfd",
  callback = function()
    vim.bo.binary = true
    vim.bo.fileencoding = ""
  end,
})

vim.keymap.set("n", "<leader>tx", "<cmd>HexToggle<CR>", {
  desc = "[T]oggle he[x] view",
})
