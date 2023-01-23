local nnoremap = require("eckon.utils").nnoremap

local M = {
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("harpoon").setup() end,
    init = function()
      nnoremap("<Leader>ha", function() require("harpoon.mark").add_file() end, { desc = "Add file to harpoon" })
      nnoremap(
        "<Leader>hh",
        function() require("harpoon.ui").toggle_quick_menu() end,
        { desc = "Open harpoon quick menu" }
      )

      for i = 1, 4, 1 do
        nnoremap(
          "<M-" .. i .. ">",
          function() require("harpoon.ui").nav_file(i) end,
          { desc = "Jump to harpoon file " .. i }
        )
      end
    end,
  },
  {
    "LeonHeidelbach/trailblazer.nvim",
    config = function()
      require("trailblazer").setup({
        trail_options = {
          newest_mark_symbol = "",
          cursor_mark_symbol = "",
          next_mark_symbol = "",
          previous_mark_symbol = "",
          number_line_color_enabled = true,
          symbol_line_enabled = true,
        },
        mappings = {
          nv = {
            motions = {
              new_trail_mark = "<A-n>",
              track_back = "<A-O>",
              peek_move_next_down = "<A-i>",
              peek_move_previous_up = "<A-o>",
            },
          },
        },
      })
    end,
  },
}

return M
