# Neovim / Vim

## Structure of nvim configuration

- [Vim plugin structure](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html)
- [Idiomatic vimrc](https://github.com/romainl/idiomatic-vimrc)


## Information and (default) Shortcuts for installed plugins

- vim-fugitive
  - in git-status
    - `=` show changes (on title or chunk)
    - `o` and `<ENTER>` to open file at chunk
    - `cc` will open commit window like `:Gcommit<ENTER>`
    - `dd` and `dv` will open diff-splitt
    - `s` will stage
      - works with visual mode
    - `u` will unstage
      - works with visual mode
    - `X` will checkout the changes (remove the changes)
- fzf (special symbols)
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
