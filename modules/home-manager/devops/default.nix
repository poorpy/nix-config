{ pkgs, ... }: {
  home.packages = with pkgs.unstable; [
    opentofu
    terragrunt
    tflint
    terraform
    terraform-docs
    terraform-ls
    hclfmt
    checkov


    aws-nuke
    awscli2
    eksctl

    kubectl
    docker-compose

    google-cloud-sdk
  ];
}
