{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption;
  cfg = config.neovim;
in
{
  options.neovim = {
    enable = lib.mkEnableOption "neovim";
    desktopEntry = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable create xdg desktop entry";
      example = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lua51Packages.lua
      lua51Packages.luarocks
      lua-language-server
      vscode-langservers-extracted
      stylua
      nixd
      nixpkgs-fmt
    ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      defaultEditor = true;
      package = pkgs.master.neovim-unwrapped;
    };

    xdg = mkIf cfg.desktopEntry {
      desktopEntries.neovim = {
        name = "Neovim";
        genericName = "Text Editor";
        exec = "wezterm start nvim %F";
        terminal = false;
        type = "Application";
        icon = "nvim";
      };

      mime.enable = true;
      mimeApps.enable = true;
      mimeApps.defaultApplications = {
        "application/json" = "neovim.desktop";
        "text/english" = "neovim.desktop";
        "text/plain" = "neovim.desktop";
        "text/x-makefile" = "neovim.desktop";
        "text/x-c++hdr" = "neovim.desktop";
        "text/x-c++src" = "neovim.desktop";
        "text/x-chdr" = "neovim.desktop";
        "text/x-csrc" = "neovim.desktop";
        "text/x-java" = "neovim.desktop";
        "text/x-moc" = "neovim.desktop";
        "text/x-pascal" = "neovim.desktop";
        "text/x-tcl" = "neovim.desktop";
        "text/x-tex" = "neovim.desktop";
        "application/x-shellscript" = "neovim.desktop";
        "text/x-c" = "neovim.desktop";
        "text/x-c++" = "neovim.desktop";
      };
    };
  };
}
