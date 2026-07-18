#!/usr/bin/env bash

# start custom markoff plugin in the context question view, interrupting it or closing the float will close neovim
nvim -c "autocmd UIEnter * ++once lua vim.schedule(function() require('markoff').open_list({ ask_context = true }) end)"
