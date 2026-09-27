vim.pack.add({
  {
    name = "hex",
    src = "https://github.com/RaafatTurki/hex.nvim",
  },
})

require("hex").setup({
  dump_cmd = "xxd -g 1 -u",
  assemble_cmd = "xxd -r",
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
