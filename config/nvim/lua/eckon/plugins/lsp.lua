local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.utils").augroup("lsp")

local M = {
  -- used for more complicated setups, all handled by the `vim.lsp.enable()` part
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", build = ":MasonUpdate", lazy = false },
    -- used in the `/lsp` folder
    { "b0o/schemastore.nvim" },
    -- show visual updates in rename action (similar to other vim-replacements)
    "smjonas/inc-rename.nvim",
  },
}

M.config = function()
  require("mason").setup()
  require("inc_rename").setup()

  -- NOTE: this is just the default, other parts might overwrite it again (e.g. root_markers)
  vim.lsp.config("*", {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
    root_markers = { ".git" },
  })

  -- NOTE: manual installation is needed
  -- NOTE: some other languages specific lsps might be configured with custom tool under `lsp_*`
  -- NOTE: lsp settings are in the `/lsp` folder, they extent (not replace) lspconfig
  vim.lsp.enable({
    "pyright",
    "cssls",
    "emmet_ls", -- html
    "html",
    "jsonls",
    "marksman",
    "tailwindcss",
    "taplo", -- toml
    "terraformls",
    "vimls",
    "yamlls",
  })

  -- enable inlay hints by default in all buffers with lsp and this feature
  vim.lsp.inlay_hint.enable(true)
end

autocmd("lspattach", {
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local bind_map = require("eckon.utils").bind_map
    local nmap = function(lhs, rhs, desc, expr)
      bind_map("n")(lhs, rhs, {
        desc = "LSP: " .. desc,
        buffer = args.buf,
        expr = expr,
      })
    end

    -- `K` is default to hover in neovim, for more see `lsp-defaults`

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

-- took from: https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples
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
        notif.icon = ev.data.params.value.kind == "end" and " "
          ---@diagnostic disable-next-line: undefined-field
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
  group = augroup,
})

return M
