-- set correct files to use correct filetypes
vim.filetype.add({
  filename = {
    ["todo.txt"] = "todotxt",
    ["done.txt"] = "todotxt",
  },
})
