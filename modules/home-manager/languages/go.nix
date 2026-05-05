{pkgs, ...}: {
  # programs.go = {
  #   enable = true;
  #   package = pkgs.master.go_1_26;
  # };

  home.packages = with pkgs; [
    master.go_1_26
    master.air
    master.gopls
    master.templ
    master.golines
    master.goreleaser
    master.gomodifytags
    master.golangci-lint
    master.golangci-lint-langserver
  ];
}
