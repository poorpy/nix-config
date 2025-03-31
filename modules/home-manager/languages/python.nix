{ pkgs, ... }: {
  home.packages = with pkgs; [
    master.uv
    master.pipx
    master.ruff
    master.mypy
    master.pyright
    master.python313
    master.python313Packages.ptpython
  ];

  programs.poetry = {
    enable = true;
    package = pkgs.master.poetry.withPlugins (ps: [
      pkgs.master.poetryPlugins.poetry-plugin-export
      pkgs.master.poetryPlugins.poetry-plugin-shell
      pkgs.master.poetryPlugins.poetry-plugin-up
    ]);
    settings = {
      virtualenvs.create = true;
      virtualenvs.in-project = true;
    };
  };
}
