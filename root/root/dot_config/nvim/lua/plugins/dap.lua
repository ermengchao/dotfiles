vim.pack.add({
  { name = 'nvim-dap', src = 'https://github.com/mfussenegger/nvim-dap' },
  { name = 'nvim-dap-ui', src = 'https://github.com/rcarriga/nvim-dap-ui' },
  { name = 'nvim-nio', src = 'https://github.com/nvim-neotest/nvim-nio' },
  { name = 'mason', src = 'https://github.com/mason-org/mason.nvim' },
  { name = 'mason-nvim-dap', src = 'https://github.com/jay-babu/mason-nvim-dap.nvim' },
  { name = 'nvim-dap-go', src = 'https://github.com/leoluz/nvim-dap-go' },
}, { load = true })

local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = {},
}

dapui.setup {
  icons = { expanded = 'v', collapsed = '>', current_frame = '*' },
  controls = {
    icons = {
      pause = '||',
      play = '>',
      step_into = '->',
      step_over = '=>',
      step_out = '<-',
      step_back = 'b',
      run_last = '>>',
      terminate = '[]',
      disconnect = 'x',
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

require('dap-go').setup {
  delve = {
    detached = vim.fn.has 'win32' == 0,
  },
}

vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<F7>', function() dapui.toggle() end, { desc = 'Debug: See last session result' })
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Debug: Set Breakpoint' })
