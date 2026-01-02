return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.fuzzy = opts.fuzzy or {}
      opts.fuzzy.implementation = "lua"
      return opts
    end,
  },
}
