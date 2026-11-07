vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('user-op-pack-hook', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'op.nvim' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end

    local result = vim.system({ 'make', 'install' }, { cwd = ev.data.path, text = true }):wait()
    if result.code ~= 0 then
      vim.notify('op.nvim: make install failed\n' .. (result.stderr or ''), vim.log.levels.ERROR)
    end
  end,
})

vim.pack.add({
  { name = 'op.nvim', src = 'https://github.com/mrjones2014/op.nvim' },
}, { load = true })

-- op.nvim uses its default configuration without calling setup().
