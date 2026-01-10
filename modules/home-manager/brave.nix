{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.brave;
in {
  options.brave = {
    enable = lib.mkEnableOption "brave browser";
  };

  config = mkIf cfg.enable {
    programs.brave.enable = true;
    xdg = {
      mime.enable = true;
      mimeApps.enable = true;
      mimeApps.defaultApplications = {
        "text/html" = "brave.desktop";
        "application/pdf" = "brave.desktop";
        "x-scheme-handler/http" = "brave.desktop";
        "x-scheme-handler/https" = "brave.desktop";
        "x-scheme-handler/about" = "brave.desktop";
        "x-scheme-handler/unknown" = "brave.desktop";
      };
    };
  };
}
