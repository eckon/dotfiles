---@type vim.lsp.Config
return {
  settings = {
    ["rust-analyzer"] = {
      -- NOTE: use clippy instead of `cargo check` for diagnostics (runs on save)
      check = { command = "clippy" },
    },
  },
}
