.PHONY: all symlinks packages

all: packages symlinks

symlinks:
	@ ./scripts/setup/symlink.sh

packages:
	@ sudo -v
	@ ./scripts/setup/install-packages.sh
