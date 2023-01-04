local nnoremap = require("eckon.utils").nnoremap

local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "kyazdani42/nvim-web-devicons" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
}

M.config = function()
  local actions = require("telescope.actions")
  require("telescope").setup({
    defaults = {
      color_devicons = true,
      layout_strategy = "vertical",
      path_display = { "truncate" },
      mappings = {
        i = {
          ["<C-j>"] = actions.cycle_history_next,
          ["<C-k>"] = actions.cycle_history_prev,
          -- allow fuzzy search over search result
          ["<C-f>"] = actions.to_fuzzy_refine,
        },
      },
    },
  })

  require("telescope").load_extension("fzf")
end

M.init = function()
  nnoremap(
    "<Leader>fa",
    function() require("telescope.builtin").grep_string({ search = vim.fn.input({ prompt = "Grep > " }) }) end,
    { desc = "Search via grep" }
  )
  nnoremap("<Leader>fA", function() require("telescope.builtin").live_grep() end, { desc = "Live search" })
  nnoremap("<Leader>fr", function() require("telescope.builtin").resume() end, { desc = "Continue previous search" })

  nnoremap(
    "<Leader>fb",
    function() require("telescope.builtin").buffers({ sort_mru = true }) end,
    { desc = "Search buffer" }
  )

  nnoremap("<Leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Search files" })
  nnoremap("<Leader>fg", function() require("telescope.builtin").git_status() end, { desc = "Search git changes" })
  nnoremap(
    "<Leader>fl",
    function() require("telescope.builtin").current_buffer_fuzzy_find() end,
    { desc = "Search current buffer" }
  )

  nnoremap("<Leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Search help" })
end

return M
