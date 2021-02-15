# Neovim / Vim

## Structure of nvim configuration

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)

## General Information

- Show color examples
  - `:source $VIMRUNTIME/syntax/hitest.vim`

## Information and (default) Shortcuts for installed plugins

- fzf
  - `CTRL-P`, `CTRL-N` insert the next/previous search query again
  - `CTRL-R` can paste a register into the query
    - `CTRL-R_"` paste the last yanked text (" Register)
  - special symbols
    - regex does not work in general (keep it simple)
    - `'` exact match
      - `'foo` -> match must have complete foo string
    - `!` do not match
      - `!foo` -> match can not have foo string
    - `^` match at start
      - `^foo` -> match must start with foo string
    - `$` match at end
      - `foo$` -> match must end with foo string
    - ` ` for AND (&&) operator
      - `foo bar` -> match must have foo and bar string
    - `|` for OR (||) operator
      - `foo | bar` -> match must have foo or bar string
    - `\ ` to use space as a character instead of an AND operator
      - `foo\ bar` -> return only when the string "foo bar" is matched, including the space
