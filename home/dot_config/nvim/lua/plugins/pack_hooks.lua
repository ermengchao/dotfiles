-- Register hooks before the first vim.pack.add(), including lockfile restores.

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('user-blink-pack-hook', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'LuaSnip' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if vim.fn.has('win32') == 0 and vim.fn.executable('make') == 1 then
      vim.system({ 'make', 'install_jsregexp' }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('op-pack-hook', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'op.nvim' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end

    local result = vim.system({ 'make', 'install' }, { cwd = ev.data.path, text = true }):wait()
    if result.code ~= 0 then
      vim.notify('op.nvim: make install failed\n' .. (result.stderr or ''), vim.log.levels.ERROR)
    end
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('user-telescope-pack-hook', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'telescope-fzf-native' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if vim.fn.executable('make') == 1 then vim.system({ 'make' }, { cwd = ev.data.path }):wait() end
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('user-treesitter-pack-hook', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'nvim-treesitter' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    pcall(vim.cmd, 'TSUpdate')
  end,
})
