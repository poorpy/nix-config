{ pkgs, ... }: {
  home.packages = with pkgs.unstable; [
    aws-nuke
    terragrunt
    opentofu
    awscli2
    eksctl
    kubectl
    terraform-ls
    hclfmt
    docker-compose
    google-cloud-sdk
  ];
}
