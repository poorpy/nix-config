{pkgs, ...}: {
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  home.packages = with pkgs; [
    master.jdt-language-server
    master.maven
    master.gradle
  ];
}
