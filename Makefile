.PHONY: setup symlinks packages

setup: packages symlinks

symlinks:
	@ ./scripts/setup/symlink.sh

packages:
	@ sudo -v
	@ ./scripts/setup/install-packages.sh


.PHONY: check format-lua format-markdown lint-markdown

check: format-lua format-markdown lint-markdown

format-lua:
	npx @johnnymorganz/stylua-bin \
		--glob '*.lua' \
		./config/nvim

format-markdown:
	npx prettier --write '**/*.md'

lint-markdown:
	npx markdownlint-cli '**/*.md' -f
