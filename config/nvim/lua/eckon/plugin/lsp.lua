local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.helper.utils").augroup("lsp")

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/b0o/schemastore.nvim",
  "https://github.com/smjonas/inc-rename.nvim",
})

require("mason").setup()
require("inc_rename").setup()

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  root_markers = { ".git" },
})

vim.lsp.enable({
  "pyright",
  "cssls",
  "emmet_ls",
  "html",
  "jsonls",
  "marksman",
  "tailwindcss",
  "taplo",
  "terraformls",
  "vimls",
  "yamlls",
})

vim.lsp.inlay_hint.enable(true)

autocmd("lspattach", {
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local bind_map = require("eckon.helper.utils").bind_map
    local nmap = function(lhs, rhs, desc, expr)
      bind_map("n")(lhs, rhs, {
        desc = "LSP: " .. desc,
        buffer = args.buf,
        expr = expr,
      })
    end

    nmap("gd", function()
      require("snacks").picker.lsp_definitions()
    end, "Go to definitions")

    nmap("grr", function()
      require("snacks").picker.lsp_references()
    end, "Go to references")

    nmap("gri", function()
      require("snacks").picker.lsp_implementations()
    end, "Go to implementations")

    nmap("grn", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, 'Rename via "inc_rename"', true)

    nmap("gs", function()
      require("snacks").picker.lsp_symbols()
    end, "Go to buffer symbols")

    nmap("gS", function()
      require("snacks").picker.lsp_workspace_symbols()
    end, "Go to workspace symbols")
  end,
  group = augroup,
})

autocmd("LspProgress", {
  desc = "Show LSP progress independent on notifier",
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
          ---@diagnostic disable-next-line: undefined-field
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
  group = augroup,
})
