.PHONY: home system

laptop:
	sudo nixos-rebuild switch --flake .#laptop

darwin:
	./scripts/switch_darwin.sh

update:
	nix flake update
