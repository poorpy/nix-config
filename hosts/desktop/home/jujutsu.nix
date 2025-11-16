{ pkgs, ... }: {
  programs.jujutsu = with pkgs; {
    enable = true;
    package = master.jujutsu;
    settings = {
      user = {
        email = "marczynski.bartosz@gmail.com";
        name = "Bartosz Marczyński";
      };
      ui.default-command = "status";
      git.auto-local-bookmark = true;
    };
  };

  home.packages = with pkgs; [
    master.lazyjj
  ];
}
