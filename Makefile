.PHONY: home system

laptop:
	sudo nixos-rebuild switch --flake .#laptop

desktop:
	sudo nixos-rebuild switch --flake .#desktop

darwin:
	./scripts/switch_darwin.sh

vm:
	home-manager switch --flake .#bmarczyn@muc-lhvsk4	

update:
	nix flake update
