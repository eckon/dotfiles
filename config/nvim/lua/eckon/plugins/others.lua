return {
  -- General
  { "tpope/vim-sleuth" },
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "folke/flash.nvim",
    event = "BufReadPre",
    config = function()
      require("flash").setup({
        modes = {
          search = { enabled = false },
          char = { enabled = false },
        },
      })
    end,
    init = function()
      require("eckon.utils").bind_map({ "n", "o", "x" })("H", function()
        require("flash").jump()
      end, { desc = "Flash: Jump" })
    end,
  },

  -- Styling/Appearance/Special
  { "tmux-plugins/vim-tmux-focus-events" },
  {
    "MeanderingProgrammer/markdown.nvim",
    config = function()
      local custom_config = {
        heading = { backgrounds = { "DiffChange" } },
        checkbox = {
          unchecked = { highlight = "DiagnosticOk" },
          checked = { highlight = "DiagnosticInfo" },
          custom = {
            todo = { raw = "[-]", rendered = "󰥔 ", highlight = "DiagnosticWarn" },
            canceled = { raw = "[/]", rendered = "󰜺 ", highlight = "DiagnosticError" },
          },
        },
        bullet = { highlight = "DiagnosticHint" },
      }

      -- setup on wsl has no icons, so disable checkboxes for better visuals
      if require("eckon.utils").is_windows_wsl() then
        custom_config.checkbox.enabled = false
      end

      require("render-markdown").setup(custom_config)
    end,
  },
  {
    -- improved vim.ui
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup({ input = { insert_only = false } })
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
