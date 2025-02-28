{ inputs, pkgs, lib, config, ... }: {
  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  home.packages = with pkgs; [
    master.jdt-language-server
    master.maven
    master.gradle
  ];
}
