.PHONY: home system

laptop:
	nixos-rebuild switch --flake .#laptop --use-remote-sudo

desktop:
	nixos-rebuild switch --flake .#desktop --use-remote-sudo

darwin:
	./scripts/switch_darwin.sh

vm:
	home-manager switch --flake .#bmarczyn@muc-lhvsk4	

update:
	nix flake update
