vim.pack.add({
  {
    name = "op.nvim",
    src = "https://github.com/mrjones2014/op.nvim"
  }
})

require('op').setup({
  signin_on_start = false,
  biometric_unlock = true,
  sidebar = {
    side = 'right',
    width = 40,
    sections = {
      favorites = true,
      secure_notes = true,
    },
    mappings = {
      ['<CR>'] = 'default_open',
      ['go'] = 'open_in_desktop_app',
      ['ge'] = 'edit_in_desktop_app',
    },
  },
  statusline_fmt = function(account_name)
    if not account_name or #account_name == 0 then
      return ' 1Password: No active session'
    end

    return string.format(' 1Password: %s', account_name)
  end,
  secret_detection_diagnostics = {
    disabled = false,
    severity = vim.diagnostic.severity.WARN,
    max_file_lines = 10000,
    disabled_filetypes = {
      'nofile',
      'TelescopePrompt',
      'NvimTree',
      'Trouble',
      '1PasswordSidebar',
    },
  }
})
