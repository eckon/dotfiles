if require("eckon.utils").run_minimal() then
  return {}
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.utils").augroup("lsp")

local M = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  cmd = { "Mason", "MasonUpdate" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      dependencies = "williamboman/mason-lspconfig.nvim",
    },
    { "j-hui/fidget.nvim", branch = "legacy" },
    { "folke/neodev.nvim" },
    { "simrat39/rust-tools.nvim" },
    { "pmizio/typescript-tools.nvim", dependencies = "nvim-lua/plenary.nvim" },
  },
}

M.config = function()
  require("fidget").setup({})
  require("neodev").setup()

  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "cssls",
      "emmet_ls",
      "html",
      "jsonls",
      "lua_ls",
      "marksman",
      "pyright",
      "rust_analyzer",
      "tailwindcss",
      "taplo",
      "tsserver",
      "vimls",
      "volar",
      "yamlls",
    },
  })

  local lspconfig = require("lspconfig")
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig[server_name].setup({
        capabilities = capabilities,
      })
    end,
    ["rust_analyzer"] = function()
      require("rust-tools").setup({
        server = { settings = { ["rust-analyzer"] = { checkOnSave = { command = "clippy" } } } },
      })
    end,
    ["tsserver"] = function()
      require("typescript-tools").setup({})
    end,
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            hint = { enable = true },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
    end,
  })
end

autocmd("lspattach", {
  desc = "Stop lsp clients on buffer if buffer too big",
  callback = function(args)
    local bufnr = args.buf
    if vim.api.nvim_buf_line_count(bufnr) < 10000 then
      return
    end

    vim.notify("stopped lsp (file too big)")
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in pairs(clients) do
      client.stop()
    end
  end,
  group = augroup,
})

autocmd("lspattach", {
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local bind_map = require("eckon.utils").bind_map
    local nmap = function(lhs, rhs, desc)
      bind_map("n")(lhs, rhs, { desc = "LSP: " .. desc, buffer = args.buf })
    end

    nmap("K", vim.lsp.buf.hover, "Hover Action")
    nmap("gK", vim.lsp.buf.signature_help, "Signature Help")
    bind_map("i")("<C-k>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "LSP: Signature Help" })

    nmap("gd", function()
      require("telescope.builtin").lsp_definitions({ show_line = false })
    end, "Go to definitions")

    nmap("gD", function()
      require("telescope.builtin").lsp_type_definitions({ show_line = false })
    end, "Go to type definitions")

    nmap("gr", function()
      require("telescope.builtin").lsp_references({ show_line = false, include_declaration = false })
    end, "Go to references")

    nmap("<Leader>fL", function()
      require("telescope.builtin").lsp_document_symbols()
    end, "Search lsp symbols")

    nmap("[d", vim.diagnostic.goto_prev, "Jump to previous diagnostic")
    nmap("]d", vim.diagnostic.goto_next, "Jump to next diagnostic")
    nmap("<Leader>ld", vim.diagnostic.open_float, "Open diagnostic float")

    nmap("<Leader>la", vim.lsp.buf.code_action, "Code action")
    nmap("<Leader>lr", vim.lsp.buf.rename, "Rename variable")
  end,
  group = augroup,
})

return M
