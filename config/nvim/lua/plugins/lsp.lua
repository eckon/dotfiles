require('fidget').setup({})

require('lsp_lines').setup()
vim.diagnostic.config({ virtual_text = false })

require('nvim-autopairs').setup()

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'html',
    'vimls',
    'sumneko_lua',
    'jsonls',
    'yamlls',
    'cssls',
    'emmet_ls',
    'taplo',
    'pyright',
    'tsserver',
    'volar',
    'rust_analyzer',
  },
})

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.stylua,
  },
})

local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    })
  end,
  ['sumneko_lua'] = function()
    lspconfig.sumneko_lua.setup({
      settings = {
        Lua = {
          runtime = { version = 'LuaJIT' },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true) },
          telemetry = { enable = false },
        },
      },
    })
  end,
})

local cmp = require('cmp')
if cmp == nil then
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- trigger autopairs after cmp completion was confirmed
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

vim.cmd([[
nnoremap <silent>K :call Show_documentation()<CR>
inoremap <C-k> <CMD>lua vim.lsp.buf.signature_help()<CR>

nnoremap gd <CMD>lua require('telescope.builtin').lsp_definitions({ show_line = false })<CR>
nnoremap gD <CMD>lua require('telescope.builtin').lsp_type_definitions({ show_line = false })<CR>
nnoremap gr <CMD>lua require('telescope.builtin').lsp_references({ show_line = false })<CR>
nnoremap [d <CMD>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d <CMD>lua vim.diagnostic.goto_next()<CR>

nnoremap <Leader>la <CMD>lua vim.lsp.buf.code_action()<CR>
nnoremap <Leader>lr <CMD>lua vim.lsp.buf.rename()<CR>
nnoremap <Leader>lf <CMD>lua vim.lsp.buf.format({ async = true })<CR>
nnoremap <Leader>ld <CMD>lua vim.diagnostic.open_float()<CR>
nnoremap <Leader>lh <CMD>lua require('lsp_lines').toggle()<CR>
nnoremap <Leader>ll <CMD>lua require('telescope.builtin').lsp_document_symbols()<CR>

" rewrite in lua, example: https://github.dev/YodaEmbedding/dotfiles/tree/master/nvim/.config/nvim/lua/plugins
function! Show_documentation() abort
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'help ' . expand('<cword>')
  else
    execute 'lua vim.lsp.buf.hover()'
  endif
endfunction
]])
