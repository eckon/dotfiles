---@type vim.lsp.Config
return {
  on_attach = function(client)
    -- Disable expensive features
    if client and client.server_capabilities then
      -- this currently results in crashes until this fix: https://github.com/neovim/neovim/issues/36257
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
}
