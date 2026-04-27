vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('user-treesitter-pack-hook', { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= 'nvim-treesitter' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    pcall(vim.cmd, 'TSUpdate')
  end,
})

vim.pack.add {{
  name = 'nvim-treesitter',
  src = 'https://github.com/nvim-treesitter/nvim-treesitter',
}}

local parsers = {
  'bash',
  'c',
  'diff',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
}

require('nvim-treesitter').install(parsers)

local function treesitter_try_attach(buf, language)
  if not vim.treesitter.language.add(language) then return end
  vim.treesitter.start(buf, language)

  if vim.treesitter.query.get(language, 'indents') ~= nil then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local available_parsers = require('nvim-treesitter').get_available()

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user-treesitter', { clear = true }),
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end

    local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
    if vim.tbl_contains(installed_parsers, language) then
      treesitter_try_attach(buf, language)
    elseif vim.tbl_contains(available_parsers, language) then
      require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
    else
      treesitter_try_attach(buf, language)
    end
  end,
})
