{ inputs, pkgs, lib, config, ... }: {
  programs.go = {
    enable = true;
    package = pkgs.master.go_1_22;
  };

  home.packages =
    let
      lint-langserver-override =
        pkgs.golangci-lint-langserver.override {
          buildGoModule = pkgs.master.buildGo122Module;
        };
      lint-override =
        pkgs.golangci-lint.override {
          buildGoModule = pkgs.master.buildGo122Module;
        };
      gopls-override =
        pkgs.gopls.override {
          buildGoModule = pkgs.master.buildGo122Module;
        };
    in
    [
      pkgs.air
      gopls-override
      lint-override
      lint-langserver-override
    ];
}
