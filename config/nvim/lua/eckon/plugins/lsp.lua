require('fidget').setup({})
require('lsp_signature').setup({ hint_enable = false })

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'cssls',
    'emmet_ls',
    'html',
    'jsonls',
    'pyright',
    'rust_analyzer',
    'sumneko_lua',
    'taplo',
    'tsserver',
    'vimls',
    'volar',
    'yamlls',
  },
})

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua,
  },
})

local lspconfig = require('lspconfig')
require('mason-lspconfig').setup_handlers({
  function(server_name)
    -- let lsp specific plugins handle the language server
    if server_name == 'rust_analyzer' then
      require('rust-tools').setup()
      return
    end

    if server_name == 'tsserver' then
      require('typescript').setup({})
      return
    end

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- this is needed for ufo plugin (folding via lsp)
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    lspconfig[server_name].setup({
      capabilities = capabilities,
      on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

        if vim.api.nvim_buf_line_count(bufnr) < 10000 then
          return
        end

        vim.notify('Stopped LSP (file too big)')
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        for _, client in pairs(clients) do
          client.stop()
        end
      end,
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
  snippet = { expand = function(args) vim.fn['vsnip#anonymous'](args.body) end },
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

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = 'buffer' } },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
})

local nnoremap = require('eckon.utils').nnoremap
local inoremap = require('eckon.utils').inoremap

nnoremap('K', function()
  -- check ufo fold before rest of the help actions
  local winid = require('ufo').peekFoldedLinesUnderCursor()
  if winid then
    return
  end

  local filetype = vim.bo.filetype
  if filetype == 'vim' or filetype == 'help' then
    vim.api.nvim_command('h ' .. vim.fn.expand('<cword>'))
    return
  end

  vim.lsp.buf.hover()
end)

inoremap('<C-k>', vim.lsp.buf.signature_help)

nnoremap('gd', function() require('telescope.builtin').lsp_definitions({ show_line = false }) end)
nnoremap('gD', function() require('telescope.builtin').lsp_type_definitions({ show_line = false }) end)
nnoremap(
  'gr',
  function() require('telescope.builtin').lsp_references({ show_line = false, include_declaration = false }) end
)

nnoremap('<Leader>ll', require('telescope.builtin').lsp_document_symbols)

nnoremap('[d', vim.diagnostic.goto_prev)
nnoremap(']d', vim.diagnostic.goto_next)

nnoremap('<Leader>la', vim.lsp.buf.code_action)
nnoremap('<Leader>lr', vim.lsp.buf.rename)
nnoremap('<Leader>lf', function() vim.lsp.buf.format({ async = true }) end)
nnoremap('<Leader>ld', vim.diagnostic.open_float)
