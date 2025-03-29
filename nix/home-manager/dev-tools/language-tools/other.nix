{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    gopls

    pyright

    nodejs

    nil
  ];
}
