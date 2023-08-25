local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
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
          ["<M-n>"] = actions.cycle_history_next,
          ["<M-p>"] = actions.cycle_history_prev,
          ["<C-b>"] = actions.delete_buffer,
          -- allow fuzzy search over search result
          ["<C-f>"] = actions.to_fuzzy_refine,
        },
      },
    },
  })

  require("telescope").load_extension("fzf")
end

M.init = function()
  local bind_map = require("eckon.utils").bind_map
  local nmap = function(lhs, rhs, desc)
    bind_map("n")(lhs, rhs, { desc = "Telescope: " .. desc })
  end

  nmap("<Leader>fa", function()
    require("telescope.builtin").grep_string({
      search = vim.fn.input({ prompt = "Grep > " }),
      additional_args = { "--hidden" },
    })
  end, "Search via grep")

  nmap("<Leader>fA", function()
    require("telescope.builtin").live_grep()
  end, "Live search")

  nmap("<Leader>fc", function()
    require("telescope.builtin").resume()
  end, "Continue previous search")

  nmap("<Leader>fr", function()
    require("telescope.builtin").oldfiles({ only_cwd = true })
  end, "Recently opened files")

  nmap("<Leader>fb", function()
    require("telescope.builtin").buffers({ sort_mru = true })
  end, "Search buffer")

  nmap("<Leader>ff", function()
    require("telescope.builtin").find_files({ hidden = true })
  end, "Search files")

  nmap("<Leader>fg", function()
    require("telescope.builtin").git_status()
  end, "Search git changes")

  nmap("<Leader>fl", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
  end, "Search current buffer")

  nmap("<Leader>fq", function()
    require("telescope.builtin").quickfix()
  end, "Search quickfix list")

  nmap("<Leader>fh", function()
    require("telescope.builtin").help_tags()
  end, "Search help")

  nmap("<Leader>fk", function()
    require("telescope.builtin").keymaps()
  end, "Search keymaps")
end

return M
