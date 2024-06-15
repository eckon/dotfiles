.PHONY: setup symlinks packages neovim

setup: packages symlinks

symlinks:
	@ ./bootstrap/symlink.sh

packages:
	@ sudo -v
	@ ./bootstrap/install-packages.sh

neovim:
	@ ./bootstrap/packages/install-neovim.sh --force


.PHONY: check format-lua format-markdown lint-markdown

check: format-lua format-markdown lint-markdown lint-scripts

format-lua:
	npx @johnnymorganz/stylua-bin \
		--glob '*.lua' \
		./config/nvim

format-markdown:
	npx prettier --write '**/*.md'

lint-markdown:
	npx markdownlint-cli '**/*.md' -f

lint-scripts:
	shellcheck -S warning **/*.sh
