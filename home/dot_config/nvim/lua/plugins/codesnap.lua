return {
  {
    "mistricky/codesnap.nvim",
    tag = "v2.0.0-beta.17",
    config = function()
      require("codesnap").setup({
        show_line_number = true,
        snapshot_config = {
          title = "",
          theme = "candy",
          background = "#00000000",
          watermark = { content = "" },
          code_config = {
            font_family = "SF Mono",
            breadcrumbs = {
              enable = true,
              separator = "/",
              color = "#80848b",
              font_family = "SF Mono",
            },
          },
          window = {
            mac_window_bar = true,
            shadow = {
              radius = 20,
              color = "#00000040",
            },
            margin = {
              x = 20,
              y = 20,
            },
            border = {
              width = 0,
              color = "#ffffff30",
            },
            title_config = {
              color = "#ffffff",
              font_family = "SF Mono",
            },
            radius = 20,
          },
        },
      })
    end,
  },
}
