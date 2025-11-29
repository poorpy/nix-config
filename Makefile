.PHONY: update nixos 

USER := $(shell whoami)
HOST := $(shell hostname)

laptop:
	nixos-rebuild switch --flake .#laptop --use-remote-sudo

update:
	nix flake update

home:
	home-manager switch --flake .#$(USER)@$(HOST)

nixos:
	nixos-rebuild switch --flake .#$(HOST) --sudo 


all: nixos home
