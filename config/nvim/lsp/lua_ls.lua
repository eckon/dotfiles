---@type vim.lsp.Config
return {
  root_markers = { ".luarc.json", ".git" },
  settings = {
    Lua = {
      hint = { enable = true },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
