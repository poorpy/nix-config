.PHONY: update nixos 

USER := $(shell whoami)
HOST := $(shell hostname)

all: nixos home

home:
	home-manager switch --flake .#$(USER)@$(HOST)

nixos:
	nixos-rebuild switch --flake .#$(HOST) --sudo 

update:
	nix flake update
