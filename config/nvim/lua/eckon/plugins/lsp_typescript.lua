return {
  -- NOTE: this handles all of ts_ls, meaning **DO NOT INSTALL** it manually
  "pmizio/typescript-tools.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require("typescript-tools").setup({
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
        },
      },
    })
  end,
}
