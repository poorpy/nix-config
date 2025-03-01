{ pkgs, ... }: {
  programs.go = {
    enable = true;
    package = pkgs.master.go_1_23;
    goPrivate = [ "go.akam.ai/*" "git.source.akamai.com/*" ];
  };

  home.packages =
    with pkgs;
    [
      master.air
      master.gopls
      master.templ
      master.golines
      master.gotools
      master.goreleaser
      master.golangci-lint
      master.golangci-lint-langserver
    ];
}
