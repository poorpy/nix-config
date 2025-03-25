{ pkgs, ... }: {
  programs.go = {
    enable = true;
    package = pkgs.master.go_1_24;
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
      unstable.golangci-lint-langserver
    ];
}
