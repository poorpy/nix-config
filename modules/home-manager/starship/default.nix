{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs = {
    overlays = [
      inputs.starship.overlays.default
    ];
  };

  home.packages = with pkgs; [
    starship
    starship-jj
  ];
  home.file.".config/starship.toml".source = ./starship.toml;
}
