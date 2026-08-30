vim.pack.add({
  {
    name = 'codesnap',
    src = 'https://github.com/mistricky/codesnap.nvim',
    version = 'v2.0.5',
  },
}, { load = true })

local codesnap = require('codesnap')
local codesnap_static = require('codesnap.static')
local config_home = vim.env.XDG_CONFIG_HOME or vim.fs.joinpath(vim.fn.expand('~'), '.config')
local config_directory = vim.fs.joinpath(config_home, 'codesnap')
local config_by_background = {
  dark = 'catppuccin-mocha.json',
  light = 'catppuccin-latte.json',
}

local loaded_config_name

local function load_codesnap_config()
  local config_name = config_by_background[vim.o.background]

  if not config_name or config_name == loaded_config_name then
    return
  end

  local config_path = vim.fs.joinpath(config_directory, config_name)
  local read_ok, lines = pcall(vim.fn.readfile, config_path)

  if not read_ok then
    vim.notify('Unable to read CodeSnap config: ' .. config_path, vim.log.levels.ERROR)
    return
  end

  local decode_ok, config = pcall(vim.json.decode, table.concat(lines, '\n'))

  if not decode_ok then
    vim.notify('Invalid CodeSnap JSON: ' .. config_path, vim.log.levels.ERROR)
    return
  end

  -- CodeSnap.nvim accepts snapshot settings, while print_eggs belongs to the CLI.
  config.print_eggs = nil
  config.show_line_number = true
  config.show_workspace = true

  local snapshot_config = config.snapshot_config
  snapshot_config.title = nil
  snapshot_config.fonts_folders = {
    vim.fs.joinpath(config_directory, 'remote_fonts'),
  }
  snapshot_config.themes_folders = {
    vim.fs.joinpath(config_directory, 'remote_themes'),
  }

  -- JSON null becomes vim.NIL. Omit it while merging, then remove the plugin's
  -- default watermark explicitly after setup (v2.0.5 re-adds the "none" sentinel).
  snapshot_config.watermark = nil

  local setup_ok, setup_error = pcall(codesnap.setup, config)

  if not setup_ok then
    vim.notify('Unable to configure CodeSnap: ' .. setup_error, vim.log.levels.ERROR)
    return
  end

  codesnap_static.config.snapshot_config.watermark = nil
  loaded_config_name = config_name
end

load_codesnap_config()

local sync_group = vim.api.nvim_create_augroup('codesnap-theme-sync', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = sync_group,
  callback = function()
    vim.schedule(load_codesnap_config)
  end,
})

vim.api.nvim_create_autocmd('OptionSet', {
  group = sync_group,
  pattern = 'background',
  callback = function()
    vim.schedule(load_codesnap_config)
  end,
})
