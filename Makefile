.PHONY: home system

laptop:
	sudo nixos-rebuild switch --flake .#laptop

desktop:
	sudo nixos-rebuild switch --flake .#desktop

darwin:
	./scripts/switch_darwin.sh

update:
	nix flake update
