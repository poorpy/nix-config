{pkgs, ...}: {
  home.packages = with pkgs; [
    master.go_1_27
    master.air
    master.gopls
    master.templ
    master.golines
    master.goreleaser
    master.govulncheck
    master.gomodifytags
    master.golangci-lint
    master.golangci-lint-langserver
  ];
}
