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
require("eckon.plugin.lsp.easy-dotnet")

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

    nmap("grt", function()
      require("snacks").picker.lsp_type_definitions()
    end, "Go to type definition")

    -- set by default neovim, aligned with closest function in snacks
    nmap("gO", function()
      require("snacks").picker.lsp_symbols()
    end, "Go to document symbol")

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
  callback = function(ev)
    local kind = ev.data.params.value.kind
    if kind == "end" then
      -- cleanup the message at the end instead of showing anything else
      vim.notify("")
      return
    end

    -- NOTE: this might be changed in the future to not spam and replace the previous message
    --       not sure how yet, guess with neovim making extui/ui2 non experimental it will be easier
    vim.notify(vim.lsp.status())
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
