.PHONY: home system

home:
	home-manager switch --flake .#poorpy@nixos

system:
	sudo nixos-rebuild switch --flake .#nixos

