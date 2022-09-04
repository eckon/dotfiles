local dap = require('dap')
require('nvim-dap-virtual-text').setup({})

dap.listeners.after['event_initialized']['repl_config'] = function()
  dap.repl.open()
end

dap.listeners.before['event_exited']['repl_config'] = function()
  dap.repl.close()
end

dap.listeners.before['event_terminated']['repl_config'] = function()
  dap.repl.close()
end

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

dap.configurations.typescript = { { name = 'Attach to process', type = 'node2', request = 'attach' } }

vim.cmd([[
nnoremap <silent> <Leader>db <CMD>lua require('dap').toggle_breakpoint()<CR>
nnoremap <silent> <Leader>dB <CMD>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>dE <CMD>lua require('dap').set_exception_breakpoints({ 'all' })<CR>
nnoremap <silent> <Leader>dK <CMD>lua require('dap.ui.widgets').hover()<CR>

nnoremap <silent> <Leader>dd <CMD>lua require('dap').continue()<CR>
nnoremap <silent> <Leader>dD <CMD>lua require('dap').terminate(); require('dap').terminate()<CR>

nnoremap <silent> <Leader>dh <CMD>lua require('dap').step_into()<CR>
nnoremap <silent> <Leader>dj <CMD>lua require('dap').step_over()<CR>
nnoremap <silent> <Leader>dl <CMD>lua require('dap').step_out()<CR>
nnoremap <silent> <Leader>dc <CMD>lua require('dap').run_to_cursor()<CR>
]])
