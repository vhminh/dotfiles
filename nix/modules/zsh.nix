{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
  };
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
}
