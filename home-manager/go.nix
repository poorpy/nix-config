{ inputs, pkgs, lib, config, ... }: {
  programs.go = {
    enable = true;
    package = pkgs.master.go_1_21;
  };

  home.packages =
    let
      lint-langserver-override =
        pkgs.unstable.golangci-lint-langserver.override {
          buildGoModule = pkgs.master.buildGo121Module;
        };
      lint-override =
        pkgs.unstable.golangci-lint.override {
          buildGoModule = pkgs.master.buildGo121Module;
        };
      gopls-override =
        pkgs.unstable.gopls.override {
          buildGoModule = pkgs.master.buildGo121Module;
        };
    in
    with pkgs; [
      air
      gopls-override
      lint-override
      lint-langserver-override
    ];
}
