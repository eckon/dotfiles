local dap = require('dap')
require('nvim-dap-virtual-text').setup({})
require('dapui').setup()

dap.listeners.after['event_initialized']['repl_config'] = function() require('dapui').open({}) end

dap.listeners.before['event_exited']['repl_config'] = function()
  require('dapui').close({})
  vim.cmd('bd! \\[dap-repl]')
end

dap.listeners.before['event_terminated']['repl_config'] = function()
  require('dapui').close({})
  vim.cmd('bd! \\[dap-repl]')
end

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

dap.configurations.typescript = { { name = 'Attach to process', type = 'node2', request = 'attach' } }

local nnoremap = require('eckon.utils').nnoremap

nnoremap('<Leader>db', require('dap').toggle_breakpoint)
nnoremap('<Leader>dK', require('dap.ui.widgets').hover)
nnoremap('<Leader>dd', require('dap').continue)
nnoremap('<Leader>dD', function()
  require('dap').terminate()
  require('dap').terminate()
end)

nnoremap('<Leader>dh', require('dap').step_into)
nnoremap('<Leader>dj', require('dap').step_over)
nnoremap('<Leader>dl', require('dap').step_out)
nnoremap('<Leader>dc', require('dap').run_to_cursor)
