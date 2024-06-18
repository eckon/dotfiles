.PHONY: setup symlinks packages neovim

setup: packages symlinks

symlinks:
	@ ./bootstrap/symlink.sh

packages:
	@ sudo -v
	@ ./bootstrap/install-packages.sh

neovim:
	@ ./bootstrap/packages/install-neovim.sh --force


.PHONY: setup-npx

# run setup-npx at least once to install the necessary tools
setup-npx:
	npm i -D @johnnymorganz/stylua-bin
	npm i -D prettier prettier-plugin-sh
	npm i -D markdownlint-cli


.PHONY: check format-lua format-markdown lint-markdown format-scripts lint-scripts

check: format-lua format-markdown lint-markdown format-scripts lint-scripts

format-lua:
	npx @johnnymorganz/stylua-bin \
		--glob '*.lua' \
		./config/nvim

format-markdown:
	npx prettier --write '**/*.md'

lint-markdown:
	npx markdownlint-cli '**/*.md' -f --ignore-path '.gitignore'

format-scripts:
	npx prettier --write '**/*.sh'

lint-scripts:
	shellcheck -S warning **/*.sh
