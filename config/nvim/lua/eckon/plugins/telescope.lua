local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "danielfalk/smart-open.nvim", dependencies = { "kkharji/sqlite.lua" } },
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
    extensions = { smart_open = { match_algorithm = "fzf" } },
  })

  require("telescope").load_extension("fzf")
  require("telescope").load_extension("smart_open")
end

M.init = function()
  local bind_map = require("eckon.utils").bind_map
  local nmap = function(lhs, rhs, desc)
    bind_map("n")(lhs, rhs, { desc = "Telescope: " .. desc })
  end

  nmap("<Leader>fa", function()
    vim.ui.input({ prompt = "Grep string" }, function(input)
      if input == nil or input == "" then
        return
      end

      require("telescope.builtin").grep_string({
        search = input,
        additional_args = { "--hidden", "--glob=!.git" },
      })
    end)
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

  -- as a fall back for now as the other smart finder is not perfect yet
  nmap("<Leader>FF", function()
    require("telescope.builtin").find_files()
  end, "Search files")

  -- try to use smart-open instead of find_files for now (later remap/replace)
  nmap("<Leader>ff", function()
    require("telescope").extensions.smart_open.smart_open({ cwd_only = true })
  end, "Search smart files")

  nmap("<Leader>fF", function()
    require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
  end, "Search all files")

  nmap("<Leader>fg", function()
    require("telescope.builtin").git_status()
  end, "Search git changes")

  nmap("<Leader>fl", function()
    require("telescope.builtin").current_buffer_fuzzy_find()
  end, "Search current buffer")

  nmap("<Leader>fq", function()
    require("telescope.builtin").quickfix()
  end, "Search quickfix list entries")

  nmap("<Leader>fQ", function()
    local quickfix_files = {}
    for _, entry in pairs(vim.fn.getqflist()) do
      table.insert(quickfix_files, vim.fn.bufname(entry.bufnr))
    end

    require("telescope.builtin").live_grep({ search_dirs = quickfix_files })
  end, "Live search in quickfix files")

  nmap("<Leader>fh", function()
    require("telescope.builtin").help_tags()
  end, "Search help")

  nmap("<Leader>fk", function()
    require("telescope.builtin").keymaps()
  end, "Search keymaps")
end

return M
