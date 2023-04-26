local nnoremap = require("eckon.utils").nnoremap

local M = {
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
