# used if no other argument is given to just (needs to stay at the top)
@_default:
  just --list

# setup whole configuration
[group('setup')]
setup: packages symlinks

# symlink all given configurations
[group('setup')]
@symlinks:
  ./bootstrap/symlink.sh

# install/updated all packages
[group('setup')]
@packages:
  sudo -v
  ./bootstrap/install-packages.sh

# force reinstall of latest neovim nightly release
[confirm('This will overwrite neovim, are you sure? (y/N)')]
[group('setup')]
@neovim:
  ./bootstrap/packages/install-neovim.sh --force


# run all formatters and linters over the whole repo
[group('check')]
check: _dependency-npx lua-check markdown-check scripts-check

# some formatters need specific dependencies, this will install them
_dependency-npx:
  npm i -D @johnnymorganz/stylua-bin
  npm i -D prettier prettier-plugin-sh
  npm i -D markdownlint-cli


[group('lua')]
[group('check')]
lua-check: lua-format

[group('lua')]
[group('format')]
lua-format:
  npx @johnnymorganz/stylua-bin \
    --glob '*.lua' \
    ./config/nvim


[group('markdown')]
[group('check')]
markdown-check: markdown-format markdown-lint

[group('markdown')]
[group('format')]
markdown-format:
  npx prettier --write '**/*.md'

[group('markdown')]
[group('lint')]
markdown-lint:
  npx markdownlint-cli '**/*.md' -f --ignore-path '.gitignore'


[group('scripts')]
[group('check')]
scripts-check: scripts-format scripts-lint

[group('scripts')]
[group('format')]
scripts-format:
  npx prettier --write '**/*.sh'

[group('scripts')]
[group('lint')]
scripts-lint:
  shellcheck -S warning **/*.sh
