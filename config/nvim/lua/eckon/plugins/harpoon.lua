local M = {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = true,
  config = function()
    require("harpoon").setup()
  end,
  init = function()
    local bind_map = require("eckon.utils").bind_map
    local nmap = bind_map("n")

    nmap("<Leader>ha", function()
      require("harpoon.mark").add_file()
    end, { desc = "Harpoon: Add file" })

    nmap("<Leader>hh", function()
      require("harpoon.ui").toggle_quick_menu()
    end, { desc = "Harpoon: Open quick menu" })

    for i = 1, 4, 1 do
      nmap("<M-" .. i .. ">", function()
        require("harpoon.ui").nav_file(i)
      end, { desc = "Harpoon: Jump position " .. i })
    end
  end,
}

return M
