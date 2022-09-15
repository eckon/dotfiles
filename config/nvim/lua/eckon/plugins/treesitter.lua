require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'comment',
    'css',
    'fish',
    'help',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'rust',
    'typescript',
    'vim',
    'vue',
    'yaml',
  },
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
