vim.pack.add({
  {
    name = "indent-blankline",
    src = "https://github.com/lukas-reineke/indent-blankline.nvim",
  },
})

require("ibl").setup({
  indent = {
    char = "┊",
    tab_char = "┊",
  },

  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },

  exclude = {
    filetypes = {
      "dashboard",
      "neo-tree",
    },
  },
})
