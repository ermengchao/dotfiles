vim.pack.add({
  {
    name = "codesnap",
    src = "https://github.com/mistricky/codesnap.nvim",
  },
})

{{- $configHome := env "XDG_CONFIG_HOME" | default (joinPath .chezmoi.homeDir ".config") }}
local config_directory = {{ joinPath $configHome "codesnap" | toJson }}

local config_by_colorscheme = {
  ["catppuccin-latte"] = "catppuccin-latte.json",
  ["catppuccin-mocha"] = "catppuccin-mocha.json",
}

local loaded_config_name

local function load_codesnap_config(colorscheme)
  local config_name = config_by_colorscheme[colorscheme or vim.g.colors_name]

  if not config_name then
    vim.notify(
      "CodeSnap has no config for colorscheme: " .. tostring(colorscheme or vim.g.colors_name),
      vim.log.levels.WARN
    )
    return
  end

  if config_name == loaded_config_name then
    return
  end

  local config_path = vim.fs.joinpath(config_directory, config_name)
  local read_ok, lines = pcall(vim.fn.readfile, config_path)

  if not read_ok then
    vim.notify("Unable to read CodeSnap config: " .. config_path, vim.log.levels.ERROR)
    return
  end

  local decode_ok, config = pcall(vim.json.decode, table.concat(lines, "\n"))

  if not decode_ok then
    vim.notify("Invalid CodeSnap JSON: " .. config_path, vim.log.levels.ERROR)
    return
  end

  require("codesnap").setup(config)
  loaded_config_name = config_name
end

load_codesnap_config(vim.g.colors_name)

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("codesnap-theme-sync", { clear = true }),
  pattern = { "catppuccin-latte", "catppuccin-mocha" },
  callback = function(event)
    load_codesnap_config(event.match)
  end,
})
