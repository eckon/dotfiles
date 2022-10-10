require('nvim-treesitter.configs').setup({
  -- more startuptime with `all` setting, but can be ignored for now
  ensure_installed = 'all',
  highlight = {
    enable = true,
    disable = function(_, bufnr)
      if vim.api.nvim_buf_line_count(bufnr) < 10000 then
        return false
      end

      vim.notify('Stopped Treesitter (file too big)')
      return true
    end,
  },
})

require('treesitter-context').setup()
