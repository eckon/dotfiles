.PHONY: setup symlinks packages

setup: packages symlinks

symlinks:
	@ ./scripts/setup/symlink.sh

packages:
	@ sudo -v
	@ ./scripts/setup/install-packages.sh


.PHONY: format-lua format-markdown

format: format-lua format-markdown

format-lua:
	npx @johnnymorganz/stylua-bin \
		--glob '*.lua' \
		./config/nvim

format-markdown:
	npx prettier --write '**/*.md'
