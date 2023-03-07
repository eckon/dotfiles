local nnoremap = require("eckon.utils").nnoremap

local M = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<M-CR>",
            next = "<M-n>",
            prev = "<M-p>",
          },
        },
      })
    end,
  },
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    config = function()
      require("harpoon").setup()
    end,
    init = function()
      nnoremap("<Leader>ha", function()
        require("harpoon.mark").add_file()
      end, { desc = "Add file to harpoon" })

      nnoremap("<Leader>hh", function()
        require("harpoon.ui").toggle_quick_menu()
      end, { desc = "Open harpoon quick menu" })

      for i = 1, 4, 1 do
        nnoremap("<M-" .. i .. ">", function()
          require("harpoon.ui").nav_file(i)
        end, { desc = "Jump to harpoon file " .. i })
      end
    end,
  },
}

return M
