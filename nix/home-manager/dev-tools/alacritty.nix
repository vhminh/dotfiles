{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alacritty
  ];
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
