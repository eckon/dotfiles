local dap = require('dap')
local dapui = require('dapui')

dapui.setup()
require('nvim-dap-virtual-text').setup({})

dap.listeners.after['event_initialized']['dapui'] = function() dapui.open({}) end

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

dap.configurations.typescript = { { name = 'Attach to process', type = 'node2', request = 'attach' } }

local nnoremap = require('eckon.utils').nnoremap

nnoremap('<Leader>D<CR>', function() dap.continue() end)
nnoremap('<Leader>DD', function()
  dap.terminate()
  dap.terminate()
  dapui.close({})
end)

nnoremap('<Leader>Db', function() dap.toggle_breakpoint() end)
nnoremap('<Leader>Dk', function() require('dap.ui.widgets').hover() end)
nnoremap('<Leader>Dc', function() dap.run_to_cursor() end)

local Hydra = require('hydra')

Hydra({
  name = 'dap',
  hint = 'dap',
  config = {
    invoke_on_body = true,
  },
  mode = 'n',
  body = '<Leader>D<TAB>',
  heads = {
    { 'h', function() dap.step_into() end, { desc = 'step into' } },
    { 'j', function() dap.step_over() end, { desc = 'step over' } },
    { 'l', function() dap.step_out() end, { desc = 'step out' } },
  },
})
