{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.chromium;
in {
  options.chromium = {
    enable = lib.mkEnableOption "chromium browser";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "mgngbgbhliflggkamjnpdmegbkidiapm";} # remove yt shorts
        {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock origin
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
      ];
    };
    xdg = {
      mime.enable = true;
      mimeApps.enable = true;
      mimeApps.defaultApplications = {
        "text/html" = "chromium.desktop";
        "application/pdf" = "chromium.desktop";
        "x-scheme-handler/http" = "chromium.desktop";
        "x-scheme-handler/https" = "chromium.desktop";
        "x-scheme-handler/about" = "chromium.desktop";
        "x-scheme-handler/unknown" = "chromium.desktop";
      };
    };
  };
}
