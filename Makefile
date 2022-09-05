.PHONY: setup symlinks packages

setup: packages symlinks

symlinks:
	@ ./scripts/setup/symlink.sh

packages:
	@ sudo -v
	@ ./scripts/setup/install-packages.sh


.PHONY: lua

lua:
	npx @johnnymorganz/stylua-bin \
		--config-path ./config/nvim/.stylua.toml \
		--glob '*.lua' \
		--glob '!packer_compiled.lua' \
		./config/nvim
