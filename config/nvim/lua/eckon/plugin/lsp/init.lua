local autocmd = vim.api.nvim_create_autocmd
local augroup = require("eckon.helper.utils").augroup("lsp")
local cc = require("eckon.helper.custom-command").custom_command

require("eckon.plugin.lsp.nvim-lspconfig")
require("eckon.plugin.lsp.blink")
require("eckon.plugin.lsp.mason")
require("eckon.plugin.lsp.schemastore")

-- Languages with special plugins or setups
require("eckon.plugin.lsp.lazydev")
require("eckon.plugin.lsp.rustaceanvim")
require("eckon.plugin.lsp.typescript-tools")

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

-- enable inlay hints by default in all buffers with lsp and this feature
vim.lsp.inlay_hint.enable(true)

autocmd("lspattach", {
  desc = "Add lsp specific key maps for current buffer",
  callback = function(args)
    local bind_map = require("eckon.helper.utils").bind_map
    local nmap = function(lhs, rhs, desc)
      bind_map("n")(lhs, rhs, {
        desc = "LSP: " .. desc,
        buffer = args.buf,
      })
    end

    -- `K` is default to hover in neovim, see `lsp-defaults` for more

    nmap("gd", function()
      require("snacks").picker.lsp_definitions()
    end, "Go to definitions")

    nmap("grr", function()
      require("snacks").picker.lsp_references()
    end, "Go to references")

    nmap("gri", function()
      require("snacks").picker.lsp_implementations()
    end, "Go to implementations")

    nmap("gs", function()
      require("snacks").picker.lsp_symbols()
    end, "Go to buffer symbols")

    nmap("gS", function()
      require("snacks").picker.lsp_workspace_symbols()
    end, "Go to workspace symbols")
  end,
  group = augroup,
})

-- taken from: https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md#-examples
autocmd("LspProgress", {
  desc = "Show LSP progress independent on notifier",
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
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

cc.add("Toggle inlay hints", {
  desc = "Enable and disable inlay hints",
  callback = function()
    if vim.lsp.inlay_hint.is_enabled() then
      vim.lsp.inlay_hint.enable(false)
    else
      vim.lsp.inlay_hint.enable(true)
    end
  end,
})
