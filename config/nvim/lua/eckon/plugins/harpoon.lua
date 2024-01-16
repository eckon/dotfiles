local M = {
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  branch = "harpoon2",
  lazy = true,
  config = function()
    require("harpoon").setup()
  end,
  init = function()
    local bind_map = require("eckon.utils").bind_map
    local nmap = bind_map("n")

    nmap("<Leader>ha", function()
      require("harpoon"):list():append()
    end, { desc = "Harpoon: Add file" })

    nmap("<Leader>hh", function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Harpoon: Open quick menu" })

    for i = 1, 4, 1 do
      nmap("<M-" .. i .. ">", function()
        require("harpoon"):list():select(i)
      end, { desc = "Harpoon: Jump position " .. i })
    end
  end,
}

return M
