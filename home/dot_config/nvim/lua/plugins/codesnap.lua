return {
  {
    "mistricky/codesnap.nvim",
    tag = "v2.0.0-beta.17",
    config = function()
      require("codesnap").setup({
        show_line_number = true,
        snapshot_config = {
          code_config = {
            breadcrumbs = {
              enable = true,
              separator = "/",
              color = "#80848b",
              font_family = "CaskaydiaCove Nerd Font",
            },
          },
          watermark = {
            content = "",
          },
          background = "#00000000",
        },
      })
    end,
  },
}
