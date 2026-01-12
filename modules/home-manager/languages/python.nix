{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    master.uv
    master.pipx
    master.ruff
    master.mypy
    master.pyright
    master.python313
    master.python313Packages.ptpython
    inputs.fix-python.packages.${pkgs.system}.default
  ];

  programs.poetry = {
    enable = true;
    package = pkgs.unstable.poetry.withPlugins (ps: [
      pkgs.unstable.poetryPlugins.poetry-plugin-export
      pkgs.unstable.poetryPlugins.poetry-plugin-shell
      pkgs.unstable.poetryPlugins.poetry-plugin-up
    ]);
    settings = {
      virtualenvs.create = true;
      virtualenvs.in-project = true;
    };
  };
}
